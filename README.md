# palworld-docker

[![Check Update](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/update.yml)
[![Build Docker Image](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml/badge.svg)](https://github.com/KagurazakaNyaa/palworld-docker/actions/workflows/build.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/kagurazakanyaa/palworld)
![Docker Stars](https://img.shields.io/docker/stars/kagurazakanyaa/palworld)
![Image Size](https://img.shields.io/docker/image-size/kagurazakanyaa/palworld/latest)

Palworld dedicated server with docker

## Environments

| Variable           | Describe                                                    | Default Values | Allowed Values       |
|--------------------|-------------------------------------------------------------|----------------|----------------------|
| MAX_PLAYERS        | Change the maximum number of participants on the server.    | 32             | 1-32                 |
| GAME_PORT          | Change the port number used to listen to the server.        | 8211           | 1024-65535           |
| ENABLE_MULTITHREAD | Improves performance in multi-threaded CPU environments.    | true           | true/false           |
| IS_PUBLIC          | Setup server as a community server.                         | false          | true/false           |
| PUBLIC_IP          | If not specified, it will be detected automatically.        |                | all vaild ip address |
| PUBLIC_PORT        | If not specified, it will be detected automatically.        |                | 1024-65535           |
| FORCE_UPDATE       | Whether the server should be update each time start.        | false          | true/false           |

## Volumes

|Path                      |Describe              |
|--------------------------|----------------------|
|`/opt/palworld/Pal/Saved` |Game config and saves.|

NOTE: If you use bind instead of volume to mount, you need to manually change the volume owner to uid=1000.
In the case of the docker-compose.yml of the example, you need to execute `chown -R 1000:1000 ./data`
