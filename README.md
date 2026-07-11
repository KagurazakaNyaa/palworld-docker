# palworld-docker

[![Check Update](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml)
[![Build Docker Image](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/kagurazakanyaa/palworld)
![Docker Stars](https://img.shields.io/docker/stars/kagurazakanyaa/palworld)
![Image Size](https://img.shields.io/docker/image-size/kagurazakanyaa/palworld/latest)

Palworld dedicated server with docker

## Environments

The variables below control startup behavior. PalServer options follow the official [Palworld server arguments](https://docs.palworldgame.com/settings-and-operation/arguments/) reference.

| Variable           | Description | Default | Allowed values |
|--------------------|-------------|---------|----------------|
| MAX_PLAYERS        | Maximum number of players (`-players`). | 32 | positive integer |
| GAME_PORT          | UDP port used by the server (`-port`). | 8211 | 1024-65535 |
| ENABLE_MULTITHREAD | Enable `-NumberOfWorkerThreadsServer` using `WORKER_THREADS`. | true | true/false |
| ENABLE_LEGACY_MULTITHREAD | Add `-useperfthreads`, `-NoAsyncLoadingThread`, and `-UseMultithreadForDS`. Palworld v1.0 notes that leaving these unset may improve performance. | false | true/false |
| WORKER_THREADS     | Number of server worker threads (`-NumberOfWorkerThreadsServer`). Applied only when `ENABLE_MULTITHREAD=true`. | 4 | positive integer |
| LOG_FORMAT         | Server log format (`-logformat`). | text | Text or Json |
| IS_PUBLIC          | List the server as a community server (`-publiclobby`). | false | true/false |
| PUBLIC_IP          | Public address advertised by a community server (`-publicip`). Auto-detected when unset. | | valid IP address |
| PUBLIC_PORT        | Public port advertised by a community server (`-publicport`). This does not change the listening port. | | 1024-65535 |
| FORCE_UPDATE       | Update and validate the server through SteamCMD before startup. This is a container option, not a PalServer argument. | false | true/false |

The variables below are image defaults applied only when `PalWorldSettings.ini` is first created. To apply them again, delete `/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` and restart the container.

| Variable        | Description | Default | Allowed values |
|-----------------|-------------|---------|----------------|
| SERVER_NAME     | Server name | Default Palworld Server | string |
| SERVER_DESC     | Server description | Default Palworld Server | string |
| ADMIN_PASSWORD  | Administrator password | changeme | string |
| SERVER_PASSWORD | Server password | | string |
| RCON_ENABLED    | Enable deprecated RCON support | false | true/false |
| RCON_PORT       | RCON TCP port | 25575 | 1024-65535 |
| RESTAPI_ENABLED | Enable REST API | false | true/false |
| RESTAPI_PORT    | REST API TCP port | 8212 | 1024-65535 |
| CROSSPLAY_PLATFORMS | Platforms allowed to connect (`CrossplayPlatforms`) | Steam,Xbox,PS5,Mac | comma-separated Steam, Xbox, PS5, Mac |

RCON is deprecated and scheduled for removal by Palworld. Neither RCON nor the REST API is designed to be exposed directly to the Internet; restrict access to a trusted network. See the official [RCON](https://docs.palworldgame.com/api/rcon/) and [REST API](https://docs.palworldgame.com/api/rest-api/palwold-rest-api/) documentation.

For balance changes, edit `/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` directly. See the official [configuration parameters](https://docs.palworldgame.com/settings-and-operation/configuration/) reference.

## Volumes

|Path                                   |Describe               |
|---------------------------------------|-----------------------|
|`/opt/palworld/Pal/Saved`              |Game config and saves. |
|`/opt/palworld/Pal/Content/Paks/MOD`   |Game mod pak files.    |

NOTE: If you use bind instead of volume to mount, you need to manually change the volume owner to uid=1000.
In the case of the docker-compose.yml of the example, you need to execute `chown -R 1000:1000 ./data ./mods`
Please make sure the permissions and owners of the pak file you placed in the mods directory are correct.
