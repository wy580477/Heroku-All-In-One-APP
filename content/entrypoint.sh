#!/bin/sh

VERSION="$(curl --retry 10 --retry-max-time 60 https://api.github.com/repos/iawia002/lux/releases/latest | jq .tag_name | sed 's/\"//g;s/v//g')"
curl -s --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/iawia002/lux/releases/download/v${VERSION}/lux_${VERSION}_Linux_64-bit.tar.gz -o - | tar -zxf - -C /usr/bin

exec runsvdir -P /etc/service