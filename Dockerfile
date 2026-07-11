FROM cm2network/steamcmd:steam

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/palworld

RUN /home/steam/steamcmd/steamcmd.sh +login anonymous +quit
RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit

# Container lifecycle
ENV FORCE_UPDATE=false

# PalServer startup
ENV GAME_PORT=8211
ENV MAX_PLAYERS=32
ENV LOG_FORMAT=text
# PUBLIC_IP and PUBLIC_PORT apply only when IS_PUBLIC=true.
ENV IS_PUBLIC=false
ENV PUBLIC_IP=
ENV PUBLIC_PORT=

# Server identity and access
ENV SERVER_NAME="Default Palworld Server"
ENV SERVER_DESC="Default Palworld Server"
ENV SERVER_PASSWORD=

# Remote administration
# Do not expose RCON or the REST API directly to the Internet.
ENV ADMIN_PASSWORD=changeme
ENV RCON_ENABLED=false
ENV RCON_PORT=25575
ENV RESTAPI_ENABLED=false
ENV RESTAPI_PORT=8212

# Crossplay
ENV CROSSPLAY_PLATFORMS=Steam,Xbox,PS5,Mac

# Performance
# Palworld v1.0 recommends leaving the legacy performance flags disabled.
ENV ENABLE_MULTITHREAD=false
ENV WORKER_THREADS=
# Empty values preserve DefaultPalWorldSettings.ini defaults.
ENV BASE_CAMP_MAX_NUM=
ENV BASE_CAMP_MAX_NUM_IN_GUILD=4
ENV BASE_CAMP_WORKER_MAX_NUM=
ENV ITEM_CONTAINER_FORCE_MARK_DIRTY_INTERVAL=
ENV MAX_BUILDING_LIMIT_NUM=
ENV PHYSICS_ACTIVE_DROP_ITEM_MAX_NUM=
ENV SERVER_REPLICATE_PAWN_CULL_DISTANCE=

# Backups
# Enabling world backups increases disk load.
ENV ENABLE_BACKUP_SAVE_DATA=

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE ${GAME_PORT}/udp ${RCON_PORT}/tcp ${RESTAPI_PORT}/tcp

# fix permission
RUN mkdir -p /opt/palworld/Pal/Saved
RUN mkdir -p /opt/palworld/Pal/Content/Paks/MOD
VOLUME [ "/opt/palworld/Pal/Saved", "/opt/palworld/Pal/Content/Paks/MOD" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]
