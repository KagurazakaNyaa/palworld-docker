#!/bin/bash
set -e

settings_file=/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

escape_sed_replacement() {
    printf '%s' "$1" | sed 's/[\\&|]/\\&/g'
}

escape_ini_string() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

set_quoted_setting() {
    local key=$1
    local value
    value=$(escape_ini_string "$2")
    value=$(escape_sed_replacement "$value")
    sed -i -E "s|([,(])${key}=\"[^\"]*\"|\\1${key}=\"${value}\"|" "$settings_file"
}

set_scalar_setting() {
    local key=$1
    local value
    value=$(escape_sed_replacement "$2")
    sed -i -E "s|([,(])${key}=[^,)]*|\\1${key}=${value}|" "$settings_file"
}

set_bool_setting() {
    local key=$1
    case $2 in
        true) set_scalar_setting "$key" True ;;
        false) set_scalar_setting "$key" False ;;
        *) printf 'Invalid boolean value for %s: %s\n' "$key" "$2" >&2; exit 1 ;;
    esac
}

set_crossplay_platforms() {
    local value
    value=$(escape_sed_replacement "$1")
    sed -i -E "s|([,(])CrossplayPlatforms=\([^)]*\)|\\1CrossplayPlatforms=(${value})|" "$settings_file"
}

main() {
if [[ -n $FORCE_UPDATE ]] && [[ $FORCE_UPDATE == "true" ]]; then
    /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit
fi

if [[ ! -f $settings_file ]]; then
    mkdir -p /opt/palworld/Pal/Saved/Config/LinuxServer/
    cp /opt/palworld/DefaultPalWorldSettings.ini "$settings_file"
    if [[ -n $SERVER_NAME ]]; then
        set_quoted_setting ServerName "$SERVER_NAME"
    fi
    if [[ -n $SERVER_DESC ]]; then
        set_quoted_setting ServerDescription "$SERVER_DESC"
    fi
    if [[ -n $ADMIN_PASSWORD ]]; then
        set_quoted_setting AdminPassword "$ADMIN_PASSWORD"
    fi
    if [[ -n $SERVER_PASSWORD ]]; then
        set_quoted_setting ServerPassword "$SERVER_PASSWORD"
    fi
    if [[ -n $RCON_ENABLED ]]; then
        set_bool_setting RCONEnabled "$RCON_ENABLED"
    fi
    if [[ -n $RCON_PORT ]]; then
        set_scalar_setting RCONPort "$RCON_PORT"
    fi
    if [[ -n $RESTAPI_ENABLED ]]; then
        set_bool_setting RESTAPIEnabled "$RESTAPI_ENABLED"
    fi
    if [[ -n $RESTAPI_PORT ]]; then
        set_scalar_setting RESTAPIPort "$RESTAPI_PORT"
    fi
    if [[ -n $CROSSPLAY_PLATFORMS ]]; then
        set_crossplay_platforms "$CROSSPLAY_PLATFORMS"
    fi
fi

server_opts=(
    "-port=$GAME_PORT"
    "-players=$MAX_PLAYERS"
)
if [[ -n $ENABLE_LEGACY_MULTITHREAD ]] && [[ $ENABLE_LEGACY_MULTITHREAD == "true" ]]; then
    server_opts+=(
        -useperfthreads
        -NoAsyncLoadingThread
        -UseMultithreadForDS
    )
fi
if [[ -n $ENABLE_MULTITHREAD ]] && [[ $ENABLE_MULTITHREAD == "true" ]]; then
    if [[ -n $WORKER_THREADS ]]; then
        server_opts+=("-NumberOfWorkerThreadsServer=$WORKER_THREADS")
    fi
fi
if [[ -n $LOG_FORMAT ]]; then
    server_opts+=("-logformat=$LOG_FORMAT")
fi
if [[ -n $IS_PUBLIC ]] && [[ $IS_PUBLIC == "true" ]]; then
    server_opts+=(-publiclobby)
    if [[ -n $PUBLIC_IP ]]; then
        server_opts+=("-publicip=$PUBLIC_IP")
    fi
    if [[ -n $PUBLIC_PORT ]]; then
        server_opts+=("-publicport=$PUBLIC_PORT")
    fi
fi

if [ $# -eq 0 ]; then
    exec /opt/palworld/PalServer.sh "${server_opts[@]}"
else
    exec "$@"
fi
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    main "$@"
fi
