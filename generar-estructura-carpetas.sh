#!/bin/bash

# Define the base directory
BASE_DIR="multiserver"

# Create the directory structure
mkdir -p "$BASE_DIR/cache/jellyfin"
mkdir -p "$BASE_DIR/config/bazarr"
mkdir -p "$BASE_DIR/config/cloudflare-warp-vpn"
mkdir -p "$BASE_DIR/config/jellyfin"
mkdir -p "$BASE_DIR/config/prowlarr"
mkdir -p "$BASE_DIR/config/qbittorrent"
mkdir -p "$BASE_DIR/config/radarr"
mkdir -p "$BASE_DIR/config/readarr"
mkdir -p "$BASE_DIR/config/sabnzbd"
mkdir -p "$BASE_DIR/config/scripts"
mkdir -p "$BASE_DIR/config/sonarr"
mkdir -p "$BASE_DIR/config/ssl"

# Create files in the config/scripts and config/ssl directories
cp "entrypoint.sh" "$BASE_DIR/config/scripts/entrypoint.sh"

# Create the data directory structure
mkdir -p "$BASE_DIR/data/media/books"
mkdir -p "$BASE_DIR/data/media/movies"
mkdir -p "$BASE_DIR/data/media/music"
mkdir -p "$BASE_DIR/data/media/tv"
mkdir -p "$BASE_DIR/data/torrents/books"
mkdir -p "$BASE_DIR/data/torrents/movies"
mkdir -p "$BASE_DIR/data/torrents/music"
mkdir -p "$BASE_DIR/data/torrents/tv"
mkdir -p "$BASE_DIR/data/usenet/complete"
mkdir -p "$BASE_DIR/data/usenet/incomplete"

echo "Directory structure created successfully."

# Copy the docker-compose.yml to the 'multiserver' directory
cp "docker-compose.yml" "$BASE_DIR/docker-compose.yml"
echo "docker-compose.yml copied successfully."

# Generate certificates
sslKeyPath="$BASE_DIR/config/ssl/ssl.key"
sslCrtPath="$BASE_DIR/config/ssl/ssl.crt"
sslPfxPath="$BASE_DIR/config/ssl/ssl.pfx"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$sslKeyPath" -out "$sslCrtPath"
openssl pkcs12 -export -out "$sslPfxPath" -inkey "$sslKeyPath" -in "$sslCrtPath"

echo "Certificates generated successfully."