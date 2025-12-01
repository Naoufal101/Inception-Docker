#!/bin/bash

set -e

# Colors for output (optional, for readability)
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

MYSQL_ROOT_PASSWORD=$(cat /run/secrets/my_secret)
MYSQL_PASSWORD=$(cat /run/secrets/my_other_secret)

# Define a lock file in the persistent volume
INIT_FLAG_FILE="/var/lib/mysql/.init_complete"

# Check if already initialized
if [ ! -f "$INIT_FLAG_FILE" ]; then

    # Check if environment variables are set
    if [ -z "$MYSQL_DATABASE" ]; then
        echo -e "${RED}Error: MYSQL_DATABASE is not set${NC}"
        exit 1
    fi

    if [ -z "$MYSQL_USER" ]; then
        echo -e "${RED}Error: MYSQL_USER is not set${NC}"
        exit 1
    fi

        
    # Start MariaDB in background for initialization
    mariadbd-safe &
    MARIADB_PID=$!

    # Wait for MariaDB to be ready
    echo -e "${GREEN}Waiting for MariaDB to start...${NC}"
    for i in {1..30}; do
        if mariadb-admin ping  --silent 2>/dev/null; then
            echo -e "${GREEN}MariaDB is ready!${NC}"
            break
        fi
        echo "Waiting... ($i/30)"
        sleep 1
    done

    #set pass_word for root
    echo -e "${GREEN}Setting root passWord"
    mariadb <<-EOF
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
        FLUSH PRIVILEGES;
EOF

    # Create database
    echo -e "${GREEN}Creating database: $MYSQL_DATABASE${NC}"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOF
        CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
EOF

    # Create user and grant privileges
    echo -e "${GREEN}Creating user: $MYSQL_USER${NC}"
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOF
        CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
        GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
        FLUSH PRIVILEGES;
EOF

    # Fix ownership of database directory to mysql user
    echo -e "${GREEN}Fixing database directory ownership...${NC}"
    chown -R mysql:mysql /var/lib/mysql/$MYSQL_DATABASE

    # Stop the background MariaDB process
    echo -e "${GREEN}Stopping MariaDB for clean restart...${NC}"
    mariadb-admin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

    # Wait for process to finish
    wait $MARIADB_PID 2>/dev/null || true

    echo -e "${GREEN}MariaDB initialization complete!${NC}"

    # --- CRITICAL STEP: CREATE THE FLAG FILE ---
    touch "$INIT_FLAG_FILE"
fi

# Start MariaDB in foreground as PID 1
echo -e "${GREEN}Starting MariaDB...${NC}"
exec mariadbd-safe