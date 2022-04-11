FROM vcxpz/baseimage-alpine-glibc:2.34-r0

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="ESPHome version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV PIPFLAGS="--no-cache-dir --find-links https://packages.hyde.services/alpine/wheels/ --find-links https://wheel-index.linuxserver.io/alpine/ --find-links https://wheel-index.linuxserver.io/homeassistant/" \
	PYTHONPATH="${PYTHONPATH}:/pip-packages" \
	PLATFORMIO_GLOBALLIB_DIR=/piolibs

RUN set -xe && \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies \
		cargo \
		g++ \
		gcc \
		jq \
		libffi-dev \
		python3-dev && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache \
		openssl-dev \
		py3-pip \
		python3 && \
	pip install --no-cache-dir --upgrade \
		cython \
		pip \
		reedsolo \
		setuptools \
		wheel && \
	echo "**** install esphome ****" && \
	if [ -z ${VERSION} ]; then \
		VERSION=$(curl -sL https://api.github.com/repos/esphome/esphome/releases/latest | \
			jq -r '.tag_name'); \
	fi && \
	pip install ${PIPFLAGS} \
		esphome=="${VERSION}" && \
	echo "**** configure platformio ****" && \
    platformio settings set enable_telemetry No && \
    platformio settings set check_libraries_interval 1000000 && \
    platformio settings set check_platformio_interval 1000000 && \
    platformio settings set check_platforms_interval 1000000 && \
    mkdir -p /piolibs && \
	echo "**** cleanup ****" && \
	apk del --purge \
		build-dependencies && \
	for cleanfiles in *.pyc *.pyo; \
  		do \
  		find /usr/lib/python3.*  -iname "${cleanfiles}" -exec rm -f '{}' + ; \
	done && \
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
