# User Documentation

## Services Provided

The Inception Docker stack provides:

- **WordPress Website** - Your website CMS at `https://your-domain.com`
- **MariaDB Database** - Stores all website data 
- **Nginx Web Server** - Serves website securely over HTTPS
- **Adminer** - Database management tool at `http://localhost:8080`
- **Redis Commander** - Cache monitor at `http://localhost:8081`
- **FTP Server** - Upload files directly via FTP at `ftp://localhost:21`

---

## Start and Stop

### Start Services
```bash
make build
make up          # Foreground - see logs
make up-d        # Background - free terminal
```

First startup takes 2-5 minutes.

### Stop Services
```bash
make stop        # Stop, keep data
make down        # Stop & remove containers, keep data
make start       # Restart stopped services
make fclean      # Delete everything (⚠️ data loss)
```

---

## Access Website & Administration

### Your Website
1. Open browser: `http://localhost:1313`
2. SSL warning is normal - click "Proceed"

### WordPress Admin Panel
1. Go to: `https://your-domain.com/wp-admin`
2. Username: Value in `srcs/.env` file (variable: `WP_ADMIN_USER`)
3. Password: Content of `secrets/wp_admin_password.txt`

### Adminer (Database UI)
1. Open: `http://localhost:8080`
2. Server: `mariadb`
3. Username: Value in `srcs/.env` (variable: `MYSQL_USER`)
4. Password: Content of `secrets/db_password.txt`

### Redis Commander
- Open: `http://localhost:8081`
- No login needed

### FTP Access
- Host: `localhost`
- Port: `21`
- Username: Value in `srcs/.env` (variable: `FTP_USER`)
- Password: Content of `secrets/ftp_password.txt`

---

## Locate & Manage Credentials

### Where Credentials Are Stored

**Configuration** (`srcs/.env`):
- Usernames and site settings
- View: `cat srcs/.env`

**Passwords** (`secrets/` directory):
- `db_password.txt` - Database user password
- `db_root_password.txt` - Database root password
- `wp_admin_password.txt` - WordPress admin password
- `ftp_password.txt` - FTP user password
- View: `cat secrets/wp_admin_password.txt`

### Change Credentials

1. Edit the file:
   ```bash
   nano srcs/.env              # Edit usernames
   nano secrets/db_password.txt # Edit passwords
   ```

2. Restart services:
   ```bash
   make down
   make up
   ```
   or
   ```bash
   make re #Wipe everything and begin from scratch
   ```
   

4. Or change WordPress password in admin panel (easier)

### Keep Credentials Secure
- Never share `secrets/` folder or `srcs/.env`
- Never commit to version control
- Backup in secure location
- Use strong passwords (20+ chars, mixed case, numbers)

---

## Check Services Running

### Quick Status
```bash
docker compose -f srcs/docker-compose.yaml ps
```

Status meanings:
- ✅ **Up** - Running normally
- ❌ **Exited** - Stopped (check logs)
- ⏳ **Starting** - Initializing

### View Logs
```bash
# All services
docker compose -f srcs/docker-compose.yaml logs -f

# Specific service
docker compose -f srcs/docker-compose.yaml logs wordpress
docker compose -f srcs/docker-compose.yaml logs mariadb
docker compose -f srcs/docker-compose.yaml logs nginx
```

Press `Ctrl+C` to stop viewing logs.

---

**Last Updated**: January 2026
