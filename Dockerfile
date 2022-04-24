FROM alpine:latest

COPY ./content /.aria2allinoneworkdir/

ARG MODE=build

RUN apk add --no-cache curl caddy jq bash findutils runit rclone apache2-utils tzdata ttyd ffmpeg \
    && wget -qO - https://github.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip | busybox unzip -qd /.aria2allinoneworkdir/ariang - \
    && wget -qO - https://github.com/rclone/rclone-webui-react/releases/latest/download/currentbuild.zip | busybox unzip -qd /.aria2allinoneworkdir/rcloneweb - \
    && wget -qO - https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip | busybox unzip -qd /.aria2allinoneworkdir/homer - \
    && wget -qO - https://github.com/P3TERX/Aria2-Pro-Core/releases/download/1.36.0_2021.08.22/aria2-1.36.0-static-linux-amd64.tar.gz | tar -zxf - -C /usr/bin \
    && sed -i 's|6800|443|g' /.aria2allinoneworkdir/ariang/js/aria-ng-f1dd57abb9.min.js \
    && curl -fsSL https://raw.githubusercontent.com/wy580477/filebrowser-install/master/get.sh | bash \
    && chmod +x /.aria2allinoneworkdir/service/*/run /.aria2allinoneworkdir/service/*/log/run /.aria2allinoneworkdir/aria2/*.sh /.aria2allinoneworkdir/*.sh /.aria2allinoneworkdir/luxa /.aria2allinoneworkdir/merge \
    && mv /.aria2allinoneworkdir/merge /usr/bin \
    && mv /.aria2allinoneworkdir/luxa /usr/bin \
    && ln -s /.aria2allinoneworkdir/service/* /etc/service/

ENTRYPOINT ["sh","/.aria2allinoneworkdir/entrypoint.sh"]
