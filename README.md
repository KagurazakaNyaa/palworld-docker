# palworld-docker

[![Check Update](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml)
[![Build Docker Image](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/kagurazakanyaa/palworld)
![Docker Stars](https://img.shields.io/docker/stars/kagurazakanyaa/palworld)
![Image Size](https://img.shields.io/docker/image-size/kagurazakanyaa/palworld/latest)

Palworld dedicated server with docker

## Environments

### Container lifecycle

| Variable | Description | Default | Allowed values |
|----------|-------------|---------|----------------|
| FORCE_UPDATE | Update and validate the server through SteamCMD before startup. | false | true/false |

### PalServer startup

These variables follow the official [Palworld server arguments](https://docs.palworldgame.com/settings-and-operation/arguments/) reference.

| Variable | Description | Default | Allowed values |
|----------|-------------|---------|----------------|
| GAME_PORT | UDP port used by the server (`-port`). | 8211 | 1024-65535 |
| MAX_PLAYERS | Maximum number of players (`-players`). | 32 | positive integer |
| LOG_FORMAT | Server log format (`-logformat`). | text | Text or Json |
| IS_PUBLIC | List the server as a community server (`-publiclobby`). | false | true/false |
| PUBLIC_IP | Public address advertised by a community server (`-publicip`). Auto-detected when unset. | | valid IP address |
| PUBLIC_PORT | Public port advertised by a community server (`-publicport`). This does not change the listening port. | | 1024-65535 |

The configuration variables below are applied only when `PalWorldSettings.ini` is first created. To apply them again, delete `/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` and restart the container.

### Server identity and access

| Variable | Description | Default | Allowed values |
|----------|-------------|---------|----------------|
| SERVER_NAME | Server name | Default Palworld Server | string |
| SERVER_DESC | Server description | Default Palworld Server | string |
| SERVER_PASSWORD | Server password | | string |

### Remote administration

| Variable | Description | Default | Allowed values |
|----------|-------------|---------|----------------|
| ADMIN_PASSWORD | Administrator password | changeme | string |
| RCON_ENABLED | Enable deprecated RCON support | false | true/false |
| RCON_PORT | RCON TCP port | 25575 | 1024-65535 |
| RESTAPI_ENABLED | Enable REST API | false | true/false |
| RESTAPI_PORT | REST API TCP port | 8212 | 1024-65535 |

RCON is deprecated and scheduled for removal by Palworld. Neither RCON nor the REST API is designed to be exposed directly to the Internet; restrict access to a trusted network. See the official [RCON](https://docs.palworldgame.com/api/rcon/) and [REST API](https://docs.palworldgame.com/api/rest-api/palwold-rest-api/) documentation.

### Crossplay

| Variable | Description | Default | Allowed values |
|----------|-------------|---------|----------------|
| CROSSPLAY_PLATFORMS | Platforms allowed to connect (`CrossplayPlatforms`) | Steam,Xbox,PS5,Mac | comma-separated Steam, Xbox, PS5, Mac |

### Performance

The first two variables control startup arguments. The remaining variables are first-create INI settings. Empty defaults preserve the value from Palworld's bundled `DefaultPalWorldSettings.ini`.

| Variable | Setting | Default | Allowed values / notes |
|----------|---------|---------|------------------------|
| ENABLE_MULTITHREAD | `-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS` | false | true/false; Palworld v1.0 notes that leaving these unset may improve performance |
| WORKER_THREADS | `-NumberOfWorkerThreadsServer` value | | positive integer; used only when `ENABLE_MULTITHREAD=true` |
| BASE_CAMP_MAX_NUM | `BaseCampMaxNum` | Palworld default | integer; official range not specified |
| BASE_CAMP_MAX_NUM_IN_GUILD | `BaseCampMaxNumInGuild` | 4 | maximum 10; higher values increase processing load |
| BASE_CAMP_WORKER_MAX_NUM | `BaseCampWorkerMaxNum` | Palworld default | maximum 50; higher values increase processing load |
| ITEM_CONTAINER_FORCE_MARK_DIRTY_INTERVAL | `ItemContainerForceMarkDirtyInterval` | Palworld default | resynchronization interval in seconds; advanced setting |
| MAX_BUILDING_LIMIT_NUM | `MaxBuildingLimitNum` | Palworld default | integer; 0 means unlimited |
| PHYSICS_ACTIVE_DROP_ITEM_MAX_NUM | `PhysicsActiveDropItemMaxNum` | Palworld default | integer; official range not specified |
| SERVER_REPLICATE_PAWN_CULL_DISTANCE | `ServerReplicatePawnCullDistance` | Palworld default | 5000-15000 centimeters |

### Backups

| Variable | INI setting | Default | Allowed values / notes |
|----------|-------------|---------|------------------------|
| ENABLE_BACKUP_SAVE_DATA | `bIsUseBackupSaveData` | Palworld default | true/false; enabling backups increases disk load |

For balance changes, edit `/opt/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini` directly. See the official [configuration parameters](https://docs.palworldgame.com/settings-and-operation/configuration/) reference.

## Volumes

|Path                                   |Describe               |
|---------------------------------------|-----------------------|
|`/opt/palworld/Pal/Saved`              |Game config and saves. |
|`/opt/palworld/Pal/Content/Paks/MOD`   |Game mod pak files.    |

NOTE: If you use bind instead of volume to mount, you need to manually change the volume owner to uid=1000.
In the case of the docker-compose.yml of the example, you need to execute `chown -R 1000:1000 ./data ./mods`
Please make sure the permissions and owners of the pak file you placed in the mods directory are correct.
