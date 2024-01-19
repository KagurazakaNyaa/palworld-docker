#!/bin/bash
set -e
if [[ -n $FORCE_UPDATE ]] && [[ $FORCE_UPDATE == "true" ]];then
    steamcmd +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit
fi

extra_opts=""
if [[ -n $ENABLE_MULTITHREAD ]] && [[ $ENABLE_MULTITHREAD == "true" ]];then
    extra_opts="-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
fi
community_opts=""
if [[ -n $IS_PUBLIC ]] && [[ $IS_PUBLIC == "true" ]];then
    community_opts="EpicApp=PalServer"
fi
if [[ -n $PUBLIC_IP ]];then
    community_opts="$community_opts -publicip=$PUBLIC_IP"
fi
if [[ -n $PUBLIC_PORT ]];then
    community_opts="$community_opts -publicport=$PUBLIC_PORT"
fi

if [ $# -eq 0 ];then
    /opt/palworld/PalServer.sh port="$GAME_PORT" players="$MAX_PLAYERS" "$extra_opts" "$community_opts"
else
    exec "$@"
fi