#!/bin/sh

DIR_TMP="$(mktemp -d)"
VERSION="$(curl --retry 10 --retry-max-time 60 https://api.github.com/repos/rclone/rclone/releases/latest | jq .tag_name | sed 's/\"//g')"
wget -qO - https://github.com/rclone/rclone/releases/download/${VERSION}/rclone-${VERSION}-linux-amd64.zip | busybox unzip -qd ${DIR_TMP} -
install -m 755 ${DIR_TMP}/rclone-${VERSION}-linux-amd64/rclone /usr/bin
rm -rf ${DIR_TMP}