FROM alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="RadPenguin version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV CRON="0 * * * *"
ENV CHECK_URL=
ENV SYNC_SRC=
ENV SYNC_DEST=
ENV SYNC_OPTS=-v
ENV RCLONE_OPTS="--config /config/rclone.conf"
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
  find /usr/bin | sort && \
  echo "**** cleanup ****" && \
  apk del --purge build-dependencies && \
  rm -rf /tmp/*

COPY entrypoint.sh /
COPY sync.sh /

VOLUME ["/config"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]
