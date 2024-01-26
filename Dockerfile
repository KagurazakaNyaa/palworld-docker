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
# ENV FORCE_UPDATE=false
ENV SERVER_NAME="Default Palworld Server"
ENV SERVER_DESC="Default Palworld Server"
ENV ADMIN_PASSWORD=changeme
ENV SERVER_PASSWORD=
ENV RCON_ENABLED=false
ENV RCON_PORT=25575

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN curl -L https://github.com/VeroFess/PalWorld-Server-Unoffical-Fix/releases/download/1.3.0-Update-2/PalServer-Linux-Test-Patch-Update-2 -o /tmp/PalServer-Linux-Test &&\
    mv -f /tmp/PalServer-Linux-Test /opt/palworld/Pal/Binaries/Linux/PalServer-Linux-Test &&\
    chmod +x /opt/palworld/Pal/Binaries/Linux/PalServer-Linux-Test

EXPOSE ${GAME_PORT}/udp ${RCON_PORT}/tcp

# fix permission
RUN mkdir -p /opt/palworld/Pal/Saved
RUN mkdir -p /opt/palworld/Pal/Content/Paks/MOD
VOLUME [ "/opt/palworld/Pal/Saved", "/opt/palworld/Pal/Content/Paks/MOD" ]

ENTRYPOINT [ "/docker-entrypoint.sh" ]