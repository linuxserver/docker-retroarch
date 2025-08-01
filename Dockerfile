# syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RETROARCH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=RetroArch

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/retroarch-logo.png && \
  echo "**** install packages ****" && \
  apt-key adv \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys 3B2BA0B6750986899B189AFF18DAAE7FECA3745F && \
  echo \
    "deb https://ppa.launchpadcontent.net/libretro/stable/ubuntu noble main" > \
    /etc/apt/sources.list.d/retroarch.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libretro-core-info \
    retroarch \
    retroarch-assets \
    unzip && \
  echo "**** install retroarch profiles ****" && \
  curl -o \
    /tmp/autoconfig.zip \
    https://buildbot.libretro.com/assets/frontend/autoconfig.zip && \
  mkdir -p /usr/share/libretro/autoconfig && \
  unzip \
    /tmp/autoconfig.zip \
    -d /usr/share/libretro/autoconfig && \
  echo "**** cleanup ****" && \
  printf \
    "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" \
    > /build_version && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
