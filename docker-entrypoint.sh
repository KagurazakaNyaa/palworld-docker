#!/bin/bash
set -e
if [[ -n $FORCE_UPDATE ]] && [[ $FORCE_UPDATE == "true" ]];then
    steamcmd +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit
fi

extra_opt=""
if [[ -n $ENABLE_MULTITHREAD ]] && [[ $ENABLE_MULTITHREAD == "true" ]];then
    extra_opt="-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"
fi

if [ $# -eq 0 ];then
    /opt/palworld/PalServer.sh -port "$GAME_PORT" -players "$MAX_PLAYERS" "$extra_opt"
else
    exec "$@"
fi