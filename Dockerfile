FROM vcxpz/baseimage-alpine-glibc:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="ESPHome version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

RUN set -xe && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		py3-pip && \
	if [ -z ${VERSION} ]; then \
		VERSION=$(curl -sX GET https://api.github.com/repos/esphome/esphome/releases/latest | \
			jq -r '.tag_name'); \
	fi && \
	pip3 install -U \
		pip && \
	pip3 install -U \
		esphome=="${VERSION}" && \
	echo "**** cleanup ****" && \
	rm -rf \
		/tmp/* \
		/root/.cache

# environment settings
ENV HOME="/tmp/platformio"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6052
VOLUME /config
