FROM alpine:latest

COPY ./content /.aria2allinoneworkdir/

ARG MODE=build

RUN apk add --no-cache --virtual .build-deps curl caddy jq aria2 bash findutils runit rclone apache2-utils tzdata \
    && wget -O - https://github.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip | busybox unzip -d /.aria2allinoneworkdir/ariang - \
    && wget -O - https://github.com/rclone/rclone-webui-react/releases/latest/download/currentbuild.zip | busybox unzip -d /.aria2allinoneworkdir/rcloneweb - \
    && wget -O - https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip | busybox unzip -d /.aria2allinoneworkdir/homer - \
    && sed -i 's|6800|443|g' /.aria2allinoneworkdir/ariang/js/aria-ng-f1dd57abb9.min.js \
    && curl -fsSL https://raw.githubusercontent.com/wy580477/filebrowser-install/master/get.sh | bash \
    && chmod +x /.aria2allinoneworkdir/service/*/run /.aria2allinoneworkdir/service/*/log/run /.aria2allinoneworkdir/aria2/*.sh /.aria2allinoneworkdir/*.sh \
    && ln -s /.aria2allinoneworkdir/service/* /etc/service/

ENTRYPOINT ["runsvdir","-P","/etc/service"]
