# purpurmc-docker
Unofficial docker image for [purpurmc](https://purpurmc.org/) with a few extra features.

## Usage Example
```
docker run -v "/host/purpur:/opt/purpur" -e EULA=true -e UPDATE=true -e MEMORY=2G ghcr.io/n0r1uno/purpurmc-docker
```
- default version is `1.20.1`
- `EULA=true` is required
- add `UPDATE=true` to always download the version's latest purpurmc build on startup
- pass custom jvm arguments with `ARGS="..."`
- mount `/opt/purpur` to persist data
- root user not recommended (see below)
- experimental: mount `/ramdisk` to use ramdisk mode (see below)

## Run as unprivileged user (linux only)
By setting `UID` and `GID` to an unprivileged user, the server will run as that user instead of root. \
The user must exist on the host system and have read/write access to the mounted volume.

Example to create an unprivileged user `minecraft` on the host system, set up permissions and run the container as that user:
1. `useradd --no-create-home -s /sbin/nologin -U minecraft`
2. `mkdir -p /opt/purpur`
3. `chown -R minecraft:minecraft /opt/purpur`
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
      - VERSION=1.20.1
      - UPDATE=true
      - MEMORY=4G
    volumes:
      - /opt/purpur:/opt/purpur
    ports:
      - 25565:25565
    restart: unless-stopped
```

## Experimental: Ramdisk mode (linux only)
Ramdisk mode runs the server in a tmpfs, resulting in faster read/write speeds (mostly noticeable during chunk operations). \
All worlds and important configs will be backed up every `BACKUP=30m` (default) and on container stop.

❗️ Notice: Ramdisk mode is experimental and can result in data loss if the system crashes. \
This mode only makes sense if your system runs on a slow HDD but has sufficient RAM. If you've got a fast SSD, you probably won't notice any difference. 
In general, I wouldn't use it if the server has no problems with chunk operations. Otherwise, just try it out and see if it gives you any benefits.
More info can be found [here](https://minecraft.fandom.com/wiki/Tutorials/Ramdisk_enabled_server).

To create a 4GB ramdisk run the following commands as root (or with sudo) on your host system.
1. `mkdir -p /ramdisk`
2. `mount -t tmpfs -o size=4G tmpfs /ramdisk` \
For more information (e.g. auto-mount on system startup) see [ArchWiki](https://wiki.archlinux.org/title/Tmpfs#tmp.mount)

To use ramdisk mode, mount your ramdisk to `/ramdisk` in the container. The backup interval can be changed with `BACKUP=...` (default is 30m). \
Example: `docker run -v "/ramdisk:/ramdisk" -e BACKUP=1h ...`