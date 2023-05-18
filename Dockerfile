# syntax=docker/dockerfile:1

FROM ghcr.io/imagegenius/baseimage-ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG ESPHOME_VERSION
LABEL build_version="ImageGenius Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydazz"

# environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
  PLATFORMIO_GLOBALLIB_DIR=/piolibs

RUN set -xe && \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    iputils-ping \
    openssh-client \
    python3 \
    python3-pip && \
  pip install --upgrade \
    reedsolo \
    setuptools \
    wheel && \
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
  pip install \
    -r requirements.txt \
    -r requirements_optional.txt && \
  python3 script/platformio_install_deps.py platformio.ini --libraries && \
  pip install \
    esphome=="${ESPHOME_VERSION}" && \
  echo "**** cleanup ****" && \
  for cleanfiles in *.pyc *.pyo; do \
    find /usr/local/lib/python3.* /usr/lib/python3.* -name "${cleanfiles}" -delete; \
  done && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6052
VOLUME /config
