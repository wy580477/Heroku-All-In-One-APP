#!/bin/sh

# Install Rclone
DIR_TMP="$(mktemp -d)"
VERSION="$(curl --retry 10 --retry-max-time 60 https://api.github.com/repos/rclone/rclone/releases/latest | jq .tag_name | sed 's/\"//g')"
wget -qO - https://github.com/rclone/rclone/releases/download/${VERSION}/rclone-${VERSION}-linux-amd64.zip | busybox unzip -qd ${DIR_TMP} -
install -m 755 ${DIR_TMP}/rclone-${VERSION}-linux-amd64/rclone /usr/bin
rm -rf ${DIR_TMP}

# Install Aria2
wget -qO - https://github.com/P3TERX/Aria2-Pro-Core/releases/download/1.36.0_2021.08.22/aria2-1.36.0-static-linux-amd64.tar.gz | tar -zxf - -C /usr/bin