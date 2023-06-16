#!/bin/sh

shutdown() {
    if [ -d /ramdisk ]; then
        sh /opt/backup.sh full
    fi
    exit 0
}

trap "shutdown" TERM
trap "shutdown" INT
trap "shutdown" QUIT

mkdir -p /opt/purpur/
cd /opt/purpur/

if [ ! -f server.jar ] || [ "$UPDATE" = "true" ]; then
    echo "> downloading latest $VERSION server jar..."
    rm -f server.jar
    curl https://api.purpurmc.org/v2/purpur/$VERSION/latest/download --output server.jar
    echo "> done."
fi

if [ "$EULA" = "true" ]; then
    echo "eula=true" > eula.txt
fi

if [ -d /ramdisk ]; then 
    echo "> initializing ramdisk..."
    rm -rf /ramdisk/*
    cp -r /opt/purpur/* /ramdisk
    sh -c "while true; 
        do sleep ${BACKUP}
        sh /opt/backup.sh
    done" &
    cd /ramdisk
fi

PURPUR="java -server -Xms$MEMORY -Xmx$MEMORY"
if [ "$INCUBATOR" = "true" ]; then
    PURPUR="$PURPUR --add-modules=jdk.incubator.vector"
fi
PURPUR="$PURPUR -jar server.jar nogui"

if [ ! -z $UID ] || [ ! -z $GID ]; then
    echo "> setting up permissions..."
    caps="-cap_$(seq -s ","-cap_ 0 $(cat /proc/sys/kernel/cap_last_cap))"
    SETPRIV="setpriv --clear-groups --inh-caps=$caps"
    if [ ! -z $UID ]; then
        SETPRIV="$SETPRIV --reuid=$UID"
        chown -R "$UID" "/opt/purpur/"
        if [ -d /ramdisk ]; then
            chown -R "$UID" /ramdisk
        fi
    fi
    if [ ! -z $GID ]; then
        SETPRIV="$SETPRIV --regid=$GID"
        chown -R ":$GID" "/opt/purpur/"
        if [ -d /ramdisk ]; then
            chown -R ":$GID" /ramdisk
        fi
    fi
  PURPUR="$SETPRIV $PURPUR"
  echo "> done."
fi

echo "> starting purpurmc server v$VERSION ..."
$PURPUR
shutdown