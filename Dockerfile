FROM vcxpz/baseimage-alpine-glibc:latest

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="ESPHome version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV PIPFLAGS="--no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine/ --find-links https://wheel-index.linuxserver.io/homeassistant/" \
	PYTHONPATH="${PYTHONPATH}:/pip-packages" \
	PY39_REPOS="-X http://dl-cdn.alpinelinux.org/alpine/v3.15/community -X http://dl-cdn.alpinelinux.org/alpine/v3.15/main"

RUN set -xe && \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies ${PY39_REPOS} \
		cargo \
		g++ \
		gcc \
		jq \
		libffi-dev \
		python3-dev==3.9.7-r4 && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache ${PY39_REPOS} \
		openssl-dev \
		py3-pip==20.3.4-r1 \
		python3==3.9.7-r4 && \
	pip install --no-cache-dir --upgrade \
		cython \
		pip \
		setuptools \
		wheel && \
	echo "**** patch libffi libs ****" && \
	ln -s /usr/lib/libffi.so.8 /usr/lib/libffi.so.7 && \
	echo "**** install esphome ****" && \
	if [ -z ${VERSION} ]; then \
		VERSION=$(curl -sL https://api.github.com/repos/esphome/esphome/releases/latest | \
			jq -r '.tag_name'); \
	fi && \
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
