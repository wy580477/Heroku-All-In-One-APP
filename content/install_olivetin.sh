#!/bin/sh

DIR_TMP="$(mktemp -d)"
VERSION="$(curl --retry 10 --retry-max-time 60 https://api.github.com/repos/OliveTin/OliveTin/releases/latest | jq .tag_name | sed 's/\"//g')"
curl -s --retry 10 --retry-max-time 20 -H "Cache-Control: no-cache" -fsSL github.com/OliveTin/OliveTin/releases/download/${VERSION}/OliveTin-${VERSION}-Linux-amd64.tar.gz -o - | tar -zxf - -C ${DIR_TMP}
mv ${DIR_TMP}/OliveTin-2022-04-07-linux-amd64/OliveTin /usr/bin/
mkdir -p /var/www/olivetin
mv ${DIR_TMP}/webui/* /var/www/olivetin/

rm -rf ${DIR_TMP}