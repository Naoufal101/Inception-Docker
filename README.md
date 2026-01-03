*This project has been created as part of the 42 curriculum by nhimad.*

# Inception - Docker

## Description

**Inception** is a comprehensive Docker-based infrastructure project that demonstrates system administration and containerization best practices. The project requires setting up a multi-container application featuring WordPress, MariaDB, Nginx, and various support services, all orchestrated through Docker Compose.

### Goal

The primary goal is to build a production-ready containerized WordPress environment that showcases:
- Infrastructure as Code (IaC) principles
- Docker best practices and container orchestration
- Security through secrets management
- Network isolation and service communication
- Persistent data management with volumes
- SSL/TLS certificate generation and management

### Overview

The project creates a complete WordPress stack with:
- **Core Services**: MariaDB (database), WordPress (application), Nginx (web server)
- **Bonus Services**: Redis (caching), Redis Commander (Redis UI), Adminer (DB UI), FTP server, custom website

All services are isolated in Docker containers, communicate through a custom network, and persist data through managed volumes.

---

## Instructions

### Installation & Setup

#### 1. Clone the Repository

```bash
git clone <repository-url>
cd Inception-Docker
```

#### 2. Create Environment Configuration

Create `srcs/.env` with your configuration:

```bash
# DOMAIN & GENERAL SETTINGS
DOMAIN_NAME=your-domain.com
DATA_PATH=/home/your-user/data

# MARIADB DATABASE CONFIGURATION
MYSQL_DATABASE=WordPress
MYSQL_USER=wordpress_user
MYSQL_PASSWORD=secure_password
MYSQL_ROOT_PASSWORD=root_password

# WORDPRESS CONFIGURATION
WP_SITE_URL=https://your-domain.com
WP_SITE_TITLE=Your Site Title
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin_password
WP_ADMIN_EMAIL=admin@your-domain.com
WP_DEFAULT_USER=user
WP_DEFAULT_USER_EMAIL=user@your-domain.com
WP_DEFAULT_USER_ROLE=author
WP_DEFAULT_THEME=twentytwentyfour

# REDIS CACHE CONFIGURATION
WP_REDIS_HOST=redis
WP_REDIS_PORT=6379

# FTP SERVER CONFIGURATION
FTP_USER=ftp_manager
FTP_PASSWORD=ftp_password

# NGINX/SSL CONFIGURATION
SSL_COUNTRY=MA
SSL_STATE=YourState
SSL_ORGANIZATION=YourOrg
SSL_COMMON_NAME=your-domain.com
```

#### 3. Create Secret Files

Create password files in `secrets/` directory (one password per file):

```bash
# secrets/db_password.txt
your_database_password

# secrets/db_root_password.txt
your_root_password

# secrets/wp_admin_password.txt
your_admin_password

# secrets/ftp_password.txt
your_ftp_password
```

**⚠️ Important**: Add `secrets/` and `srcs/.env` to `.gitignore`. Never commit these files.

#### 4. (Optional) Add Custom Root CA Certificate

For trusted SSL certificates without browser warnings check step is DEV_DOC.md file.

If no Root CA is provided, Nginx generates a self-signed certificate automatically.

### Execution

```bash
# Build all images
make build

# Build and start all services
make up

# Start in background (detached mode)
make up-d

# Stop services
make down

# Stop all, remove containers and volumes (clean slate)
make fclean

# View logs in real-time
docker compose -f srcs/docker-compose.yaml logs -f
```

## Docker Architecture & Design Choices

### Use of Docker

This project leverages Docker to:
1. **Containerization**: Isolate each service (database, web server, application) in separate containers
2. **Reproducibility**: Ensure consistent environments across development, testing, and deployment
3. **Scalability**: Easily manage multiple service instances and dependencies
4. **Security**: Use secrets management and network isolation

### Project Structure

```
srcs/requirements/          # Service configurations
├── mariadb/               # Database container
├── wordpress/             # PHP application container
├── nginx/                 # Web server container
└── bonus/                 # Additional services
    ├── redis/
    ├── redis-commander/
    ├── Adminer/
    ├── FTP/
    └── website/
```

### Architecture Comparisons

#### Virtual Machines vs Docker

**Virtual Machines**
- Size: GB (full OS)
- Startup Time: Minutes
- Resource Usage: High (per VM OS)
- Isolation: Complete OS isolation
- Use Case: Full system simulation
- In This Project: ❌ Not used

**Docker**
- Size: MB (shared OS)
- Startup Time: Seconds
- Resource Usage: Low (shared kernel)
- Isolation: Process-level isolation

#### Secrets vs Environment Variables

**Environment Variables**
- Security: Visible in process listing
- Logging: Often logged/exposed
- Persistence: Temporary per session
- Access: All processes see them
- In This Project: ✅ Configuration only

**Secrets (Files)**
- Security: File-based, not in environment
- Logging: Not logged by default
- Persistence: Persisted as files
- Access: Only services mount them
- In This Project: ✅ All passwords stored here

**Decision**: 
- **Environment variables** for non-sensitive configuration (DOMAIN_NAME, ports, etc.)

#### Docker Network vs Host Network

**Docker Network**
- Isolation: Complete isolation
- Port Mapping: Required (port forwarding)
- Service Discovery: Container names as DNS
- Security: Firewall between host/containers
- Use Case: Multi-container apps
- In This Project: ✅ Custom network used

**Host Network**
- Isolation: Shared with host
- Port Mapping: Direct host access
- Service Discovery: Need IP addresses
- Security: No separation
- Use Case: System-level access needed
- In This Project: ❌ Not used

#### Docker Volumes vs Bind Mounts

**Docker Volumes**
- Location: Docker-managed (`/var/lib/docker/volumes/`)
- Management: Docker CLI controls them
- Permissions: Automatic handling
- Performance: Optimized by Docker
- Backup: Easy with Docker tools
- Use Case: Production, managed data
- In This Project: ✅ Volumes for data_base

**Bind Mounts**
- Location: Host directory
- Management: User manages path
- Permissions: Manual setup
- Performance: Host filesystem dependent
- Backup: Requires host tools
- Use Case: Development, inspection
- In This Project: ✅ Bind mounts for config

**Decision**:
- **Volumes**: `wordpress_files` and `data_base` - managed persistence for application data
- **Bind Mounts**: Nginx config files - allows real-time editing during development

---

## Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/docs/)

### Training & Courses
- [Docker Training & Courses](https://www.docker.com/trainings/)

### Video Tutorials
- [What is a Container? (Geekific)](https://youtu.be/X2hpxp3Kq6A?si=Rls4YlAGWXLs2jYp)
- [Docker Tutorial for Beginners (TechWorld with Nana)](https://youtu.be/3c-iBn73dDE?si=oosLgrCixLVG3HWz)
- [Network Namespaces Basics Explained](https://youtu.be/j_UUnlVC2Ss?si=4OhIw9rC6maqeF7H)
- [HTTPS, SSL, TLS & Certificate Authorities](https://youtu.be/EnY6fSng3Ew?si=VAGkino1QQ1A--jZ)
- [Docker Volume Drivers & Plugins Explained](https://youtu.be/bvvTEPBqkYM?si=j9_QuGE5IqJAkyWb)

### AI Usage in This Project

Artificial Intelligence tools were utilized in the development of this project for the following purposes:

- **Concept Mastery**: Used LLMs to break down complex architectural concepts (Docker networks, PID 1, Volume mapping) and understand the interaction between services (NGINX, MariaDB, WordPress).

- **Configuration Assistance**: Used to understand syntax requirements and best practices for configuration files (`.conf`, `Dockerfile`).

- **Design Generation**: Generated the CSS styling and layout for this documentation website.

- **Integrated Documentation Assistants**: Leveraged the AI-powered search and chatbots embedded within official documentation (e.g., Docker Docs AI, MariaDB Knowledge Base) to efficiently locate specific flags and technical details.

---

**Last Updated**: January 2026
