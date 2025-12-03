#!/usr/bin/env bash
set -e

# Certificate validity periods
DAYS_CA=3650 
DAYS_SERVER=365 

# Output files
ROOT_KEY="/etc/ssl/private/rootCA.key"
ROOT_CERT="/etc/ssl/certs/rootCA.crt"
SERVER_KEY="/etc/ssl/private/server.key"
SERVER_CSR="/etc/ssl/certs/server.csr"
SERVER_CERT="/etc/ssl/certs/server.crt"
FULL_CHAIN="/etc/ssl/certs/fullchain.pem"


CONF_VA="/C=MA/ST=TTH/O=1337MED/OU=UM6P/CN=Naoufal_CA"
SCONF_VA="/C=MA/ST=TTH/O=1337MED/CN=Inception"

if [ ! -f "${FULL_CHAIN}" ]; then
        ### === 1. Generate a Root CA (private key + self-signed certificate) ===
        openssl genrsa -out "${ROOT_KEY}" 4096
        openssl req -x509 -new -key "${ROOT_KEY}" \
                -sha256 -days "${DAYS_CA}" -out "${ROOT_CERT}" \
                -subj "${CONF_VA}"

        ### === 2. Generate server private key + CSR using SAN config ===
        openssl genrsa -out "${SERVER_KEY}" 2048
        openssl req -new -key "${SERVER_KEY}" -out "${SERVER_CSR}" -subj "${SCONF_VA}"

        ### define subject Alt Name conf
        echo "subjectAltName=DNS:localhost, IP:127.0.0.1" >> san.cnf

        ### === 3. Sign the CSR with your Root CA to get server certificate (with SAN) ===
        openssl x509 -req -in "${SERVER_CSR}" -CA "${ROOT_CERT}" \
                -CAkey "${ROOT_KEY}" -out "${SERVER_CERT}" \
                -days "${DAYS_SERVER}" -sha256 -extfile san.cnf

        ### === 4. Create full chain certificate file ===
        cat ${SERVER_CERT} ${ROOT_CERT} > /etc/ssl/certs/fullchain.pem
fi

# Start MariaDB in foreground as PID 1
exec nginx -g 'daemon off;'