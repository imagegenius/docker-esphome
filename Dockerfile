FROM vcxpz/baseimage-alpine-glibc:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="ESPHome version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV PIPFLAGS="--no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine/ --find-links https://wheel-index.linuxserver.io/homeassistant/" \
	PYTHONPATH="${PYTHONPATH}:/pip-packages" \
	S6_KILL_FINISH_MAXTIME="30000"

RUN set -xe && \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies \
		cargo \
		g++ \
		gcc \
		jq \
		openssl-dev \
		libffi-dev \
		python3-dev && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		python3 \
		py3-pip && \
	if [ -z ${VERSION} ]; then \
		VERSION=$(curl -sL https://api.github.com/repos/esphome/esphome/releases/latest | \
			jq -r '.tag_name'); \
	fi && \
	pip install --no-cache-dir --upgrade \
		wheel && \
	pip install ${PIPFLAGS} \
		esphome=="${VERSION}" && \
	echo "**** cleanup ****" && \
	apk del --purge \
		build-dependencies && \
	rm -rf \
		/tmp/* \
		/root/.cache \
		/root/.cargo

# environment settings
ENV HOME="/config/"

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6052
VOLUME /config
