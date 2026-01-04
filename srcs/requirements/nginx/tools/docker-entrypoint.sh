#!/usr/bin/env bash
set -e

# Certificate validity periods
DAYS_CA=3650 
DAYS_SERVER=365 

# Output files
ROOT_KEY="/etc/inception/rootCA.key"
ROOT_CERT="/etc/inception/rootCA.crt"
SERVER_KEY="/etc/ssl/private/server.key"
SERVER_CSR="/etc/ssl/certs/server.csr"
SERVER_CERT="/etc/ssl/certs/server.crt"
FULL_CHAIN="/etc/ssl/certs/fullchain.pem"

# Build SSL subject from environment variables
SCONF_VA="/C=${SSL_COUNTRY}/ST=${SSL_STATE}/O=${SSL_ORGANIZATION}/CN=${DOMAIN_NAME}"

if [ ! -f "${FULL_CHAIN}" ]; then

        ### === Set up the config file of wordpress server for nginx ===
        cp /etc/inception/wordpress.conf /etc/nginx/sites-available/ 
        ln -s /etc/nginx/sites-available/wordpress.conf \
        /etc/nginx/sites-enabled/wordpress \
        && rm -f /etc/nginx/sites-enabled/default

        ### === Copy root crt and key in ssl directory ===
        # cp /etc/inception/rootCA.key "${ROOT_KEY}"
        # cp /etc/inception/rootCA.crt "${ROOT_CERT}"
        # ### === 1. Generate a Root CA (private key + self-signed certificate) ===
        # openssl genrsa -out "${ROOT_KEY}" 4096
        # openssl req -x509 -new -key "${ROOT_KEY}" \
        #         -sha256 -days "${DAYS_CA}" -out "${ROOT_CERT}" \
        #         -subj "${CONF_VA}"

        if [[ -f "${ROOT_KEY}" && -f "${ROOT_CERT}" ]]; then
                echo "Create a certificate for the server and sign it using the provided CA certificate"
                ### === Generate server private key + CSR using SAN config ===
                openssl genrsa -out "${SERVER_KEY}" 2048
                openssl req -new -key "${SERVER_KEY}" -out "${SERVER_CSR}" -subj "${SCONF_VA}"

                ### define subject Alt Name conf
                echo "subjectAltName=DNS:nhimad.42.fr, IP:127.0.0.1" >> san.cnf

                ### === Sign the CSR with Root CA to get server certificate (with SAN) ===
                openssl x509 -req -in "${SERVER_CSR}" -CA "${ROOT_CERT}" \
                        -CAkey "${ROOT_KEY}" -out "${SERVER_CERT}" \
                        -days "${DAYS_SERVER}" -sha256 -extfile san.cnf

                ### === Create full chain certificate file ===
                cat ${SERVER_CERT} ${ROOT_CERT} > "${FULL_CHAIN}"
        else
                echo "Create a SSC"
                ### === Generate server private key + SSC. (in Case we do not have a CA certificate) ===
                openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days "${DAYS_CA}" \
                -out "${FULL_CHAIN}" \
                -keyout "${SERVER_KEY}" \
                -subj "${SCONF_VA}"
        fi
fi

# Start MariaDB in foreground as PID 1
exec nginx -g 'daemon off;'
