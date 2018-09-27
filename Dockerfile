FROM alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="RadPenguin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV COMMAND=sync
ENV COMMAND_OPTS=-v
ENV CONFIG_OPTS="--config /config/rclone.conf"
ENV CRON="0 * * * *"
ENV DESTINATION=
ENV HEALTH_URL=
ENV SOURCE=/source
ENV TZ="America/Edmonton"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    curl \
    wget && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    ca-certificates \
    dcron \
    fuse \
    tzdata && \
  echo "**** install rclone ****" && \
  curl -o /tmp/rclone.zip -L "https://downloads.rclone.org/rclone-current-linux-amd64.zip" && \
  unzip /tmp/rclone.zip -d /tmp && \
  mv /tmp/rclone-*linux*/rclone /usr/bin/ && \
  echo "**** cleanup ****" && \
  apk del --purge build-dependencies && \
  rm -rf /tmp/*

COPY entrypoint.sh /
COPY rclone.sh /

VOLUME ["/config"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]
