<!-- DO NOT EDIT THIS FILE MANUALLY  -->

# [hydazz/esphome](https://github.com/hydazz/docker-esphome)

[![GitHub Release](https://img.shields.io/github/release/hydazz/docker-esphome.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/hydazz/docker-esphome/releases)
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=hyde.services&message=GitHub%20Package&logo=github)](https://github.com/hydazz/docker-esphome/packages)
[![Jenkins Build](https://img.shields.io/jenkins/build?labelColor=555555&logoColor=ffffff&style=for-the-badge&jobUrl=https%3A%2F%2Fci.hyde.services%2Fjob%2FDocker-Pipeline-Builders%2Fjob%2Fdocker-esphome%2Fjob%2Fubuntu%2F&logo=jenkins)](https://jenkins.hyde.services/job/Docker-Pipeline-Builders/job/docker-esphome/job/ubuntu/)
![Image Size](https://img.shields.io/docker/image-size/hydaz/esphome.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=docker)
[![CI](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=CI&query=CI&url=https%3A%2F%2Fci-tests.hyde.services%2Fesphome%2Flatest%2Fci-status.yml)](https://ci-tests.hyde.services/hydazz/esphome/latest/index.html)

[ESPHome](https://esphome.io/) - A system to control your ESP8266/ESP32 by simple yet powerful configuration files and control them remotely through Home Automation systems.

[![esphome](https://esphome.io/_static/logo-text.svg)](https://esphome.io/)

## Supported Architectures

We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list).

Simply pulling `ghcr.io/hydazz/esphome:ubuntu` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ❌ | |
| armhf| ❌ | |

## Application Setup

Access the webui at `<your-ip>:6052`, for more information check out [ESPHome](https://esphome.io/).

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose

```yaml
---
version: "2.1"
services:
  esphome:
    image: ghcr.io/hydazz/esphome:ubuntu
    container_name: esphome
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - <path to data>:/config
    ports:
      - 6052:6052
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=esphome \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 6052:6052 \
  -v <path to data>:/config \
  --restart unless-stopped \
  ghcr.io/hydazz/esphome:ubuntu
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 6052` | WebUI Port |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use, eg. Europe/London |
| `-v /config` | Appdata Path |


## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull esphome`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d esphome`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/hydazz/esphome:ubuntu`
* Stop the running container: `docker stop esphome`
* Delete the container: `docker rm esphome`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/hydazz/docker-esphome.git
cd docker-esphome
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/hydazz/esphome:ubuntu .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`

```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **1.02.23:** - Initial Release.
