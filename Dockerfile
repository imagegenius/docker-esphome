# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.24

# set version label
ARG VERSION
LABEL maintainer="hydazz"
LABEL org.opencontainers.image.authors="hydazz"

# environment settings
ENV \
  PLATFORMIO_GLOBALLIB_DIR=/piolibs \
  PIP_BREAK_SYSTEM_PACKAGES=1 \
  PIP_DISABLE_PIP_VERSION_CHECK=1 \
  PIP_NO_CACHE_DIR=1 \
  PIP_ROOT_USER_ACTION=ignore \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    cargo \
    g++ \
    gcc \
    libffi-dev \
    libc-dev \
    python3-dev && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    curl \
    gcompat \
    git \
    iputils \
    jq \
    mpfr-dev \
    openssl-dev \
    py3-pip \
    python3 && \
  pip install --upgrade \
    reedsolo \
    setuptools \
    wheel && \
  pip install --no-binary :all: \
    protobuf && \
  echo "**** install esphome ****" && \
  mkdir -p \
    /tmp/esphome \
    /piolibs && \
  curl -o \
    /tmp/esphome.tar.gz -L \
    "https://github.com/esphome/esphome/archive/${VERSION}.tar.gz" && \
  tar xf \
    /tmp/esphome.tar.gz -C \
    /tmp/esphome --strip-components=1 && \
  cd /tmp/esphome && \
  pip install \
    -r requirements.txt && \
  python3 script/platformio_install_deps.py platformio.ini --libraries && \
  pip install \
    esphome=="${VERSION}" && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  for cleanfiles in *.pyc *.pyo; do \
    find /usr/lib/python3.* -iname "${cleanfiles}" -delete; \
  done && \
  rm -rf \
    /tmp/* \
    /root/.cache \
    /root/.cargo

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6052
VOLUME /config
