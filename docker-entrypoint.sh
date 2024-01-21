#!/bin/bash
set -e
if [[ -n $FORCE_UPDATE ]] && [[ $FORCE_UPDATE == "true" ]];then
    /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit
fi

if [[ ! -f /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini ]];then
    mkdir -p /opt/palworld/Pal/Saved/Config/LinuxServer/
    cat /opt/palworld/DefaultPalWorldSettings.ini > /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    if [[ -n $SERVER_NAME ]];then
        sed -i "s^ServerName=\"Default Palworld Server\"^ServerName=\"$SERVER_NAME\"^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
    if [[ -n $SERVER_DESC ]];then
        sed -i "s^ServerDescription=\"\"^ServerDescription=\"$SERVER_DESC\"^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
    if [[ -n $MAX_PLAYERS ]];then
        sed -i "s^ServerPlayerMaxNum=32^ServerPlayerMaxNum=\"$MAX_PLAYERS\"^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
    if [[ -n $ADMIN_PASSWORD ]];then
        sed -i "s^AdminPassword=\"\"^AdminPassword=\"$ADMIN_PASSWORD\"^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
    if [[ -n $SERVER_PASSWORD ]];then
        sed -i "s^ServerPassword=\"\"^ServerPassword=\"$SERVER_PASSWORD\"^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
    if [[ -n $RCON_ENABLED ]] && [[ $RCON_ENABLED == "true" ]];then
        sed -i "s^RCONEnabled=False^RCONEnabled=True^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
    if [[ -n $RCON_PORT ]];then
        sed -i "s^RCONPort=25575^RCONPort=$RCON_PORT^g" /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
fi
chmod 666 /opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

extra_opts=""
if [[ -n $ENABLE_MULTITHREAD ]] && [[ $ENABLE_MULTITHREAD == "true" ]];then
    extra_opts="-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
fi
community_opts=""
if [[ -n $IS_PUBLIC ]] && [[ $IS_PUBLIC == "true" ]];then
    community_opts="-EpicApp=PalServer"
fi
if [[ -n $PUBLIC_IP ]];then
    community_opts="$community_opts -publicip=$PUBLIC_IP"
fi
if [[ -n $PUBLIC_PORT ]];then
    community_opts="$community_opts -publicport=$PUBLIC_PORT"
fi

if [ $# -eq 0 ];then
    /opt/palworld/PalServer.sh -port="$GAME_PORT" -players="$MAX_PLAYERS" "$extra_opts" "$community_opts"
else
    exec "$@"
fi