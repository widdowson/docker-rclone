#!/bin/bash

BUILD_DATE=$( date +%Y-%m-%d )
REPO_NAME=radpenguin/rclone-sync
VERSION=$( curl --silent https://rclone.org/downloads/ | grep "Rclone Download" | sed -e 's/^.*Rclone Download v//' )

echo "Building rclone-sync version $VERSION, build date $BUILD_DATE"
echo -n "Continue? (y/N) "
read X
if [[ "$X" != "y" ]]; then
  echo "Exiting..."
  exit 1
fi

docker login docker.io
docker build \
  --no-cache \
  --file=./Dockerfile \
  --build-arg=BUILD_DATE="$BUILD_DATE" \
  --build-arg=VERSION="$VERSION" \
  --tag=radpenguin/$REPO_NAME:latest \
  .

docker push docker.io/$REPO_NAME
