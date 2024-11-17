# syntax=docker/dockerfile:1

FROM ghcr.io/imagegenius/baseimage-alpine:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG ESPHOME_VERSION
LABEL build_version="ImageGenius Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydazz"

# environment settings
ENV PLATFORMIO_GLOBALLIB_DIR=/piolibs

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
    gcompat \
    git \
    mpfr4-dev \
    iputils \
    openssl-dev \
    py3-pip \
    python3 && \
  pip install --break-system-packages --no-cache-dir --upgrade \
    reedsolo \
    setuptools \
    wheel && \
  pip install --break-system-packages --no-binary :all: \
    protobuf && \
  echo "**** install esphome ****" && \
  mkdir -p \
    /tmp/esphome \
    /piolibs && \
  if [ -z ${ESPHOME_VERSION} ]; then \
    ESPHOME_VERSION=$(curl -sL https://api.github.com/repos/esphome/esphome/releases/latest | \
      jq -r '.tag_name'); \
  fi && \
  curl -o \
    /tmp/esphome.tar.gz -L \
    "https://github.com/esphome/esphome/archive/${ESPHOME_VERSION}.tar.gz" && \
  tar xf \
    /tmp/esphome.tar.gz -C \
    /tmp/esphome --strip-components=1 && \
  cd /tmp/esphome && \
  pip install --break-system-packages --no-cache-dir \
    -r requirements.txt \
    -r requirements_optional.txt && \
  python3 script/platformio_install_deps.py platformio.ini --libraries && \
  pip install --break-system-packages --no-cache-dir \
    esphome=="${ESPHOME_VERSION}" && \
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
