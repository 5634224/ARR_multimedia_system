# Servidor multimedia + Servidor de descargas
¿Deseas montarte el sistema multimedia y de descargas definitivo? Estás en el repo adecuado 😉.
En esta guía aprenderás a montar un sistema con:
- Sonarr (para indexar las series)
- Raddar (para indexar las películas)
- Readarr (para indexar los libros)
- Bazarr (para indexar los subtítulos)
- Prowlarr (motor/sincronizador de indexadores de todas las ARR Apps)
- Qbittorrent
- Flaresolver (es una ayuda para los sistemas de verificación humana)
- Instantprivacy (mismo propósito que flaresolver, pero distinto modo de funcionamiento a nivel interno)
- Cloudflare-warp (para pasar todo el flujo y tráfico de datos descargados por la VPN de Cloudflare)

DISCLAIMER: Este repositorio está destinado únicamente a fines educativos. Cualquier uso que no se ajuste a este propósito es responsabilidad exclusiva del usuario (se entiende usuario como la persona que está utilizando cualquier cosa del repositorio) y no se considera una garantía de soporte o responsabilidad por cualquier daño o pérdida resultante.

## Prerrequisitos:
Tener instalado docker y docker compose, principalmente. Mira este enlace:
- **Para Debian (Linux)**: https://docs.docker.com/engine/install/debian/
- **Para Windows**: https://docs.docker.com/engine/install/binaries/#install-server-and-client-binaries-on-windows

También es recomendable, aunque opcional, tener instalado git, para hacer git clone. Aunque también puedes descargar el repositorio como ZIP (arriba a la derecha según entras en el repositorio :)

## Guión:
0. Descargar este repositorio (hacer git clone).
```bash
git clone https://github.com/5634224/ARR_multimedia_system
```

1. Crear la estructura de carpetas. Esencial para el buen funcionamiento de todo el stack, como se describe a continuación.

2. Generar los certificados para usarlos para desplegar los contenedores con SSL/HTTPS (opcional).

3. Generar red interna docker para el stack, con direcciones IP **ESTÁTICAS**.

3. Después, ejecuta `docker-compose up -d` para iniciar el stack.

## Crear la estructura de carpetas recomendada por las guías de las ARR Apps
Este es el árbol general de directorios que propongo para desplegar el stack.
```
multiserver
├── cache
│   └── jellyfin
├── config
│   ├── bazarr
│   ├── cloudflare-warp-vpn
│   ├── jellyfin
│   ├── prowlarr
│   ├── qbittorrent
│   ├── radarr
│   ├── readarr
│   ├── sabnzbd
│   ├── scripts
│   │   └── entrypoint.sh
│   ├── sonarr
│   └── ssl
│       ├── ssl.crt
│       ├── ssl.key
│       └── ssl.pfx
└── data
    ├── media
    │   ├── books
    │   ├── movies
    │   ├── music
    │   └── tv
    ├── torrents
    │   ├── books
    │   ├── movies
    │   ├── music
    │   └── tv
    └── usenet
        ├── complete
        └── incomplete
```

La estructura de carpetas que nos indican las guías ARR que debemos crear es la parte que cuelga de la carpeta de ```data```. Siguiendo esta estructura, logramos que funcione el **sym-linking**, ahorrándonos espacio al no tener las descargas en dos sitios ocupando el doble de espacio, permitiendo así que el mismo archivo pueda ser localizado desde el directorio de ```torrents```, así como desde el directorio de ```media```.
Mira estos dos enlaces, si te interesa profundizar:
- https://wiki.servarr.com/docker-guide
- https://trash-guides.info/File-and-Folder-Structure/Hardlinks-and-Instant-Moves/

Por otra parte, también crearemos la carpeta ```config```, y ahí montaremos volúmenes para alojar la configuración de cada uno de los contenedores que formarán el stack de docker compose.

Puedes **generar esta estructura** mediante los scripts `generar-estructura-carpetas.ps1` (si usas Windows, con Powershell) o `generar-estructura-carpetas.sh` (si usas Linux, con Bash). Además, este script **también te ayudará a generar las claves privada y pública y el certificado** necesarios para configurar y utilizar (si así lo deseas) los contenedores con cifrado SSL/HTTPS.

## Generar certificados para hacer los contenedores SSL/HTTPs
### En Linux
Revisar el script `generar-estructura-carpetas.sh`.

Dentro de la ejecución del script, llegado el momento de la generación del certificado, si no quieres rellenar todos los campos que requiere el certificado, solo introduce algo, por ejemplo en el de country, y en el resto, pulsa enter sin introducir nada.
### En Windows
Revisar el script `generar-estructura-carpetas.ps1`.

Dentro de la ejecución del script, llegado el momento de la generación del certificado, si no quieres rellenar todos los campos que requiere el certificado, solo introduce algo, por ejemplo en el de country, y en el resto, pulsa enter sin introducir nada.
## Crear red de docker interna
Asegúrate de adaptar las direcciones IP a tu entorno local. Esto es, que el rango de IP's que elijas para los contenedores estén disponibles en la máscara de subred que elijas.
¿Por qué? Enecesario establecer la red y las direcciones IP de forma ESTÁTICA (manual) para poder enrutar, si así se desea, el tráfico de los contenedores a través de Cloudflare WARP.
### IPv4
```bash
docker network create --driver bridge --subnet=192.168.255.0/24 vpn_network
```
### (Opcional) IPv6
```bash
docker network create --driver bridge --subnet=192.168.255.0/24 --ipv6 --subnet=fd42:4242:2189:ac::/64 vpn_network
```

## Crear docker-compose.yml
Una vez ejecutado el script de creación de la estructura de carpetas, se habrá creado una copia del fichero docker-compose.yml del repositorio en tu carpeta `multiserver`.
**AVISO**: Asegúrate de adaptar las direcciones IP a su entorno local, deben estar dentro de la subred que creamos en el paso anterior.

Asegúrate de revisar que los siguientes contenedores no hayan cambiado su entrypoint, ya que de lo contrario, deberás actualizarlo en la variable de entorno `ENTRYPOINT`:
- flaresolver
- instantprivacy
- sonarr
- radarr
- bazarr
- readarr
- prowlarr
- qbittorrent

En principio, de todos los mencionados, los que provienen de linuxserver no cambiarán su entrypoint y seguirá siendo "/init", pero el de flaresolver e instantprivacy podrían cambiar en futuras actualizaciones de sus imágenes.

Para averiguar cuál es el entrypoint de tus contenedores, ejecuta:
```bash
docker ps --no-trunc
```

Y fíjate en la columna `COMMAND`. Este será el entrypoint que deberás copiar y pegar en la variable de environment del contenedor en cuestión que lo necesite dentro del docker-compose.yml

## Despliegue:
Abre una terminal, situate dentro de la carpeta multiserver y ejecuta:
```bash
docker compose up -d
```

## TODO:
- [ ] Las imágenes de flaresolver y instantprivacy no contienen el paquete ip, esencial para definir las rutas para redirigir el tráfico a través de Cloudflare WARP. Sería conveniente crear un fichero Dockerfile para generar nuestras propias imágenes customizadas incluyendo este paquete.