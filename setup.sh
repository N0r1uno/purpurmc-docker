#!/bin/sh

mkdir -p $PWD/purpur/
cd $PWD/purpur/

if [ ! -f server.jar ] || [ "$UPDATE" = "true" ]; then
    echo "> downloading latest $VERSION server jar..."
    rm -f server.jar
    wget -q https://api.purpurmc.org/v2/purpur/$VERSION/latest/download -O server.jar
    echo "> done."
fi

if [ "$EULA" = "true" ]; then
    echo "eula=true" > eula.txt
fi

if [ -z $MEMORY ]; then
    MEMORY=1G
fi

PURPUR="java -server -Xms$MEMORY -Xmx$MEMORY --add-modules=jdk.incubator.vector -jar server.jar nogui"
if [ ! -z $UID ] || [ ! -z $GID ]; then
    echo "> setting up permissions..."
    caps="-cap_$(seq -s ","-cap_ 0 $(cat /proc/sys/kernel/cap_last_cap))"
    SETPRIV="setpriv --clear-groups --inh-caps=$caps"
    if [ ! -z $UID ]; then
        SETPRIV="$SETPRIV --reuid=$UID"
        chown -R "$UID" "$PWD"
    fi
    if [ ! -z $GID ]; then
        SETPRIV="$SETPRIV --regid=$GID"
        chown -R ":$GID" "$PWD"
    fi
  PURPUR="$SETPRIV $PURPUR"
  echo "> done."
fi

echo "> starting purpurmc server v$VERSION ..."
$PURPUR