# Define the base directory
$BASE_DIR = "multiserver"

# Create the directory structure
New-Item -ItemType Directory -Force -Path "$BASE_DIR/cache/jellyfin"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/bazarr"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/cloudflare-warp-vpn"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/jellyfin"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/prowlarr"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/qbittorrent"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/radarr"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/readarr"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/sabnzbd"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/scripts"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/sonarr"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/config/ssl"

# Copy the entrypoint.sh file to the config/scripts directory
Copy-Item -Path "entrypoint.sh" -Destination "$BASE_DIR/config/scripts/entrypoint.sh" -Force

# Create the data directory structure
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/media/books"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/media/movies"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/media/music"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/media/tv"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/torrents/books"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/torrents/movies"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/torrents/music"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/torrents/tv"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/usenet/complete"
New-Item -ItemType Directory -Force -Path "$BASE_DIR/data/usenet/incomplete"

Write-Host "Directory structure created successfully."

# Copy the docker-compose.yml to the 'multiserver' directory
Copy-Item -Path "docker-compose.yml" -Destination "$BASE_DIR/docker-compose.yml" -Force
Write-Host "docker-compose.yml copied successfully."

# Generate certificates
$sslKeyPath = "$BASE_DIR/config/ssl/ssl.key"
$sslCrtPath = "$BASE_DIR/config/ssl/ssl.crt"
$sslPfxPath = "$BASE_DIR/config/ssl/ssl.pfx"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $sslKeyPath -out $sslCrtPath
openssl pkcs12 -export -out $sslPfxPath -inkey $sslKeyPath -in $sslCrtPath

Write-Host "Certificates generated successfully."