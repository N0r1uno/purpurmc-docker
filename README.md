# purpurmc-docker
Very basic, unofficial docker image for [purpurmc](https://purpurmc.org/).

## Usage Example
```
docker run -v "/host/purpur:/purpur" -e EULA=true -e UPDATE=true -e MEMORY=2G todo
```
- default version is 1.18.2
- `EULA=true` is required
- `UPDATE=true` always downloads the latest purpurmc build on startup
- root user not recommended, see below

## Run as unprivileged user
1. `useradd --no-create-home -s /sbin/nologin -U minecraft`
2. `mkdir -p /opt/purpur`
3. `chown -R minecraft:minecraft /opt/minecraft`
4. set env variables `UID` and `GUID` on startup\
   (see `id [-u/-g] minecraft`)

## Example docker-compose
 ```
 version: '3.8'

services:
  purpurmc-1-18-2:
    image: todo
    environment:
      - EULA=true
      - GID=1003
      - UID=1003
      - VERSION=1.18.2
      - UPDATE=true
      - MEMORY=2G
    volumes:
      - /opt/purpur/:/opt/purpur/
    ports:
      - 25565:25565
    restart: unless-stopped
```