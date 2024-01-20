FROM cm2network/steamcmd:steam

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/palworld

RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit

ENV GAME_PORT=8211
ENV MAX_PLAYERS=32
ENV ENABLE_MULTITHREAD=true
ENV IS_PUBLIC=false
ENV PUBLIC_IP=
ENV PUBLIC_PORT=
ENV FORCE_UPDATE=false
ENV SERVER_NAME="Default Palworld Server"
ENV SERVER_DESC="Default Palworld Server"
ENV ADMIN_PASSWORD=changeme
ENV SERVER_PASSWORD=
ENV RCON_ENABLED=false
ENV RCON_PORT=25575

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 8211/udp

# fix permission
RUN mkdir -p /opt/palworld/Pal/Saved
VOLUME [ "/opt/palworld/Pal/Saved" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]