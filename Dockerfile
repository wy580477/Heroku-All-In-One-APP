FROM alexta69/metube:latest

COPY ./content /.aria2allinoneworkdir/

RUN apk add --no-cache curl caddy jq bash findutils runit aria2 apache2-utils tzdata ttyd \
    && wget -qO - https://github.com/mayswind/AriaNg/releases/download/1.2.3/AriaNg-1.2.3.zip | busybox unzip -qd /.aria2allinoneworkdir/ariang - \
    && wget -qO - https://github.com/rclone/rclone-webui-react/releases/download/v2.0.5/currentbuild.zip | busybox unzip -qd /.aria2allinoneworkdir/rcloneweb - \
    && wget -qO - https://github.com/bastienwirtz/homer/releases/latest/download/homer.zip | busybox unzip -qd /.aria2allinoneworkdir/homer - \
    && sed -i 's|6800|443|g' /.aria2allinoneworkdir/ariang/js/aria-ng-f1dd57abb9.min.js \
    && wget -qO - https://github.com/filebrowser/filebrowser/releases/latest/download/linux-amd64-filebrowser.tar.gz | tar -zxf - -C /usr/bin \
    && chmod +x /.aria2allinoneworkdir/service/*/run /.aria2allinoneworkdir/service/*/log/run /.aria2allinoneworkdir/aria2/*.sh /.aria2allinoneworkdir/*.sh \
    && /.aria2allinoneworkdir/install_rclone.sh \
    && mv /.aria2allinoneworkdir/ytdlptorclone.sh /usr/bin/ \
    && ln -s /.aria2allinoneworkdir/service/* /etc/service/

ENV DOWNLOAD_DIR=/mnt/data/videos
ENV STATE_DIR=/.aria2allinoneworkdir/.metube
ENV OUTPUT_TEMPLATE="%(title)s_%(uploader)s.%(ext)s"

ENTRYPOINT ["sh","/.aria2allinoneworkdir/entrypoint.sh"]
