# purpurmc-docker
Very basic, unofficial docker image for [purpurmc](https://purpurmc.org/) with a few extra features.

## Usage Example
```
docker run -v "/host/purpur:/opt/purpur" -e EULA=true -e UPDATE=true -e MEMORY=2G ghcr.io/n0r1uno/purpurmc-docker
```
- default version is 1.20.1
- `EULA=true` is required
- `UPDATE=true` always downloads the latest purpurmc build on startup
- mount `/opt/purpur` to persist data
- mount `/ramdisk` to use ramdisk mode (see below)
- root user not recommended (see below)

## Run as unprivileged user (linux only)
1. `useradd --no-create-home -s /sbin/nologin -U minecraft`
2. `mkdir -p /opt/purpur`
3. `chown -R minecraft:minecraft /opt/minecraft`
4. set env variables `UID` and `GUID` on startup\
   (see `id [-u/-g] minecraft`)

## Ramdisk mode (linux only)
Ramdisk mode runs the server in a tmpfs, resulting in faster read/write speeds (mostly noticeable during chunk operations).\
This mode only makes sense if your system runs on a slow HDD but has sufficient RAM.
All worlds and important configs will be backed up every `BACKUP=30m` (default) and on container stop.\

❗️ Notice: Ramdisk mode can result in data loss if the container is stopped or the pc crashes.\

To create a ramdisk run the following commands as root (or with sudo) on your host system.\
1. `mkdir -p /ramdisk`
2. `mount -t tmpfs -o size=4G tmpfs /ramdisk`
where `size=4G` is the size of the ramdisk.\
For more information (e.g. auto-mount on system startup) see [ArchWiki](https://wiki.archlinux.org/title/Tmpfs#tmp.mount)\

## Example docker-compose
 ```
services:
  purpurmc:
    image: ghcr.io/n0r1uno/purpurmc-docker
    container_name: purpurmc
    environment:
      - EULA=true
      - GID=1003
      - UID=1003
      - VERSION=1.20.1
      - UPDATE=true
      - MEMORY=2G
      - BACKUP=1h
    volumes:
      - /opt/purpur/:/opt/purpur/
    ports:
      - 25565:25565
    restart: unless-stopped
```