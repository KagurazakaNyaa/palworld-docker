FROM cm2network/steamcmd:steam

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/palworld

RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/palworld" +login anonymous +app_update 2394010 validate +quit

ENV GAME_PORT=7777
ENV MAX_PLAYERS=16
ENV ENABLE_MULTITHREAD=true
ENV FORCE_UPDATE=false

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 7777/udp 7777/tcp

VOLUME [ "/opt/palworld/Pal/Saved" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]