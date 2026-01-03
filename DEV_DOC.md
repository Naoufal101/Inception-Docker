# Developer Documentation

## Setup from Scratch

### Prerequisites
- Docker 20.10+
- Docker Compose 2.0+
- 5GB disk space

### 1. Clone Repository
```bash
git clone <repository-url>
cd Inception-Docker
```

### 2. Create Environment File
```bash
cat > srcs/.env << 'EOF'
DOMAIN_NAME=localhost
DATA_PATH=/home/$(whoami)/data

MYSQL_DATABASE=WordPress
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=secure_password
MYSQL_ROOT_PASSWORD=root_password

WP_SITE_URL=https://localhost
WP_SITE_TITLE=Dev Site
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=admin@localhost.local
WP_DEFAULT_USER=testuser
WP_DEFAULT_USER_EMAIL=testuser@localhost.local
WP_DEFAULT_USER_ROLE=author
WP_DEFAULT_THEME=twentytwentyfour

WP_REDIS_HOST=redis
WP_REDIS_PORT=6379

FTP_USER=ftpuser
FTP_PASSWORD=ftp_password

SSL_COUNTRY=US
SSL_STATE=Dev
SSL_ORGANIZATION=Dev
SSL_COMMON_NAME=localhost
EOF
```

### 3. Create Secret Files
```bash
mkdir -p secrets
echo "secure_password" > secrets/db_password.txt
echo "root_password" > secrets/db_root_password.txt
echo "admin_password" > secrets/wp_admin_password.txt
echo "ftp_password" > secrets/ftp_password.txt
```

### 4. Add to .gitignore
```bash
echo "secrets/" >> .gitignore
echo "srcs/.env" >> .gitignore
```
### 5. (Optional) Add Custom Root CA Certificate

For trusted SSL certificates without browser warnings:

1. Place your Root CA files in `srcs/requirements/nginx/conf/`:
   - `rootCA.crt` - Root Certificate Authority certificate
   - `rootCA.key` - Root Certificate Authority private key

2. Install the certificate on your local machine:

   **Linux:**
   ```bash
   sudo cp srcs/requirements/nginx/conf/rootCA.crt /usr/local/share/ca-certificates/
   sudo update-ca-certificates
   ```

   **macOS:**
   ```bash
   sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain \
     srcs/requirements/nginx/conf/rootCA.crt
   ```

   **Windows:** Import via Certificate Manager (`certmgr.msc`)

If no Root CA is provided, Nginx generates a self-signed certificate automatically.

---

## Build and Launch

### Build Images
```bash
make build
```

### Start Services
```bash
# Foreground (see logs)
make up

# Background
make up-d
```

### Stop Services
```bash
make stop      # Keeps containers
make down      # Removes containers, keeps data
make fclean    # Complete cleanup (deletes all)
make re        # Clean rebuild
```

---

## Container and Volume Management

### Viewing Container Status

```bash
# See all containers and their status
docker compose -f srcs/docker-compose.yaml ps

```

### Container Commands

**Stop all containers:**
```bash
make stop
# or
docker compose -f srcs/docker-compose.yaml stop
```

**Restart all containers:**
```bash
make start
# or
docker compose -f srcs/docker-compose.yaml start
```

**Stop and remove containers (keeps volumes):**
```bash
make down
# or
docker compose -f srcs/docker-compose.yaml down
```

### Accessing Container Shell

Execute commands inside running containers:

```bash
# Access WordPress PHP container
docker compose -f srcs/docker-compose.yaml exec wordpress bash

# Access MariaDB container
docker compose -f srcs/docker-compose.yaml exec mariadb bash

# Access Nginx container
docker compose -f srcs/docker-compose.yaml exec nginx bash
```

### Managing Volumes

**List all volumes:**
```bash
docker volume ls
```

**Inspect a volume:**
```bash
docker volume inspect inception_wordpress_files
docker volume inspect inception_data_base
```

### Viewing Container Logs

**View logs from all services:**
```bash
docker compose -f srcs/docker-compose.yaml logs
```

**Follow logs in real-time:**
```bash
docker compose -f srcs/docker-compose.yaml logs -f
```

**View logs from a specific service:**
```bash
docker compose -f srcs/docker-compose.yaml logs wordpress
docker compose -f srcs/docker-compose.yaml logs mariadb
docker compose -f srcs/docker-compose.yaml logs nginx
```

**View last 100 lines:**
```bash
docker compose -f srcs/docker-compose.yaml logs --tail 100
```

---

## Data Storage & Persistence

### Directory Structure
```
~/data/
├── wordpress_files/     # WordPress code and uploads
└── data_base/          # MariaDB database files
```

### Persistence Details
- **Type**: Docker volumes (bind mounts to ~/data/)
- **Location**: `${DATA_PATH}` (default: ~/data/)
- **Automatic**: Data persists across container restarts
- **Manual**: Backup by copying ~/data/ directory

### Database Location
```bash
~/data/data_base/wordpress/    # WordPress database files
```

### File Storage Location
```bash
~/data/wordpress_files/        # WordPress files, uploads, plugins
```

### Verify Data Persistence
```bash
# Check data directory size
du -sh ~/data/

# List WordPress files
ls -la ~/data/wordpress_files/

# Check database files
ls -la ~/data/data_base/
```
---

**Last Updated**: January 2026
