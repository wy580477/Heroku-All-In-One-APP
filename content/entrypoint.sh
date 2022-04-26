#!/bin/sh

python3 -m pip install -U yt-dlp &
mkdir -p /mnt/data/config /mnt/data/downloads /mnt/data/videos
mv /.aria2allinoneworkdir/bashrc /mnt/data/config/
echo ${RCLONE_CONFIG_BASE64} | base64 -d  >/mnt/data/config/rclone.conf

DRIVE_NAME_AUTO="$(sed -n '1p' /mnt/data/config/rclone.conf | sed "s/\[//g" | sed "s/\]//g")"
if [ "${RCLONE_DRIVE_NAME}" = "auto" ]; then
       DRIVENAME=${DRIVE_NAME_AUTO}
else
       DRIVENAME=${RCLONE_DRIVE_NAME}
fi

sed -i "s|^drive-name=.*|drive-name=${DRIVENAME}|g" /mnt/data/config/script.conf

exec runsvdir -P /etc/service