#!/bin/sh
echo "> backing up server..."
cd /ramdisk

TS=$(date +%d-%m-%Y_%H-%M-%S)

backup() {
    echo "> backing up $1..."
    cp -r $1 /opt/purpur/$1_backup_$TS
    rm -rf /opt/purpur/$1
    mv /opt/purpur/$1_backup_$TS /opt/purpur/$1
}

if [ "$1" = "full" ]; then
    for i in "/ramdisk/"*; do
        backup $(basename "$i")
    done
else
    backup world
    backup world_nether
    backup world_the_end
    backup banned-players.json
    backup ops.json
    backup whitelist.json
    backup usercache.json
    backup banned-ips.json
fi

echo "> backup complete."