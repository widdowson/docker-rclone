FROM radpenguin/rclone:latest

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
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    dcron && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/*

COPY entrypoint.sh /
COPY rclone.sh /

VOLUME ["/config"]

ENTRYPOINT ["/entrypoint.sh"]
