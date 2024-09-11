# purpurmc-docker
Unofficial docker image for [purpurmc](https://purpurmc.org/).

## Usage Example
```
docker run -v "/someFolderOnYourMachine/purpur:/opt/purpur" -e EULA=true -e UPDATE=true -e MEMORY=4G ghcr.io/n0r1uno/purpurmc-docker
```
- default version is `1.21.1`
- `EULA=true` is required
- add `UPDATE=true` to always download the version's latest purpurmc build on startup
- pass custom jvm arguments with `ARGS="..."`
- mount `/opt/purpur` to persist data
- root user not recommended (see below)

## Run as unprivileged user (linux only)
By setting `UID` and `GID` to an unprivileged user, the server will run as that user instead of root. \
The user must exist on the host system and have read/write access to the mounted volume.

Example to create an unprivileged user `minecraft` on the host system, set up permissions and run the container as that user:
1. `useradd --no-create-home -s /sbin/nologin -U minecraft`
2. `mkdir -p /someFolderOnYourMachine/purpur`
3. `chown -R minecraft:minecraft /someFolderOnYourMachine/purpur`
4. set env variables `UID` and `GUID` on startup\
   (see `id [-u/-g] minecraft`)

## Example docker-compose
 ```
services:
  purpurmc:
    image: ghcr.io/n0r1uno/purpurmc-docker
    container_name: purpurmc
    environment:
      - EULA=true
      - GID=1001 # unprivileged user
      - UID=1001 # unprivileged user
      - VERSION=1.21.1
      - UPDATE=true
      - MEMORY=4G
    volumes:
      - /someFolderOnYourMachine/purpur:/opt/purpur
    ports:
      - 25565:25565
    restart: unless-stopped
```