# palworld-docker

[![Check Update](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml)
[![Build Docker Image](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/kagurazakanyaa/palworld)
![Docker Stars](https://img.shields.io/docker/stars/kagurazakanyaa/palworld)
![Image Size](https://img.shields.io/docker/image-size/kagurazakanyaa/palworld/fixed)

Palworld dedicated server with docker

NOTE: This fixed branch includes binaries from [unofficial sources](https://github.com/VeroFess/PalWorld-Server-Unoffical-Fix), please do not use if you do not trust this source.

## Environments

The variables in the table below affect the server's startup command, see <https://tech.palworldgame.com/dedicated-server-guide#settings> and <https://tech.palworldgame.com/community-server-guide>
| Variable           | Describe                                                    | Default Values | Allowed Values       |
|--------------------|-------------------------------------------------------------|----------------|----------------------|
| MAX_PLAYERS        | Change the maximum number of participants on the server.    | 32             | 1-32                 |
| GAME_PORT          | Change the port number used to listen to the server.        | 8211           | 1024-65535           |
| ENABLE_MULTITHREAD | Improves performance in multi-threaded CPU environments.    | true           | true/false           |
| IS_PUBLIC          | Setup server as a community server.                         | false          | true/false           |
| PUBLIC_IP          | If not specified, it will be detected automatically.        |                | all vaild ip address |
| PUBLIC_PORT        | If not specified, it will be detected automatically.        |                | 1024-65535           |

The variables in the table below only valid during initialization, if you need to make it valid, please delete `/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` and restart the container.
| Variable           | Describe                 | Default Values          | Allowed Values |
|--------------------|--------------------------|-------------------------|----------------|
| SERVER_NAME        | Server name              | Default Palworld Server | string         |
| SERVER_DESC        | Server description       | Default Palworld Server | string         |
| ADMIN_PASSWORD     | AdminPassword            |                         | string         |
| SERVER_PASSWORD    | Set the server password. |                         | string         |
| RCON_ENABLED       | Enable RCON              | false                   | true/false     |
| RCON_PORT          | Port number for RCON     | 25575                   | 1024-65535     |

For balance changes, please directly modify `/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini`, please refer to <https://tech.palworldgame.com/optimize-game-balance>

## Volumes

|Path                                   |Describe               |
|---------------------------------------|-----------------------|
|`/opt/palworld/Pal/Saved`              |Game config and saves. |
|`/opt/palworld/Pal/Content/Paks/MOD`   |Game mod pak files.    |

NOTE: If you use bind instead of volume to mount, you need to manually change the volume owner to uid=1000.
In the case of the docker-compose.yml of the example, you need to execute `chown -R 1000:1000 ./data ./mods`
Please make sure the permissions and owners of the pak file you placed in the mods directory are correct.
