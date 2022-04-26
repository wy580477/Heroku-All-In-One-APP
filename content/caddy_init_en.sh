#!/bin/bash

DRIVENAME="$(grep ^drive-name /mnt/data/config/script.conf | cut -d= -f2-)"

if [ "${RCLONE_AUTO_MODE}" = "dummy" ]; then
    sed -i "s|MODE_STATUS|</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "move" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook:<br />[move] Move files to local finished folder after download completed</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "custom" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook: [custom]</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ ! -f "/mnt/data/config/rclone.conf" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook:<br />Fail to find Rclone config file</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "copy_remote" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook:<br />[copy_remote] Move files to local finished folder after both download and seeding completed, then copy to Rclone remote ${DRIVENAME}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "copy_remote_first" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook:<br />[copy_remote_first] Copy files to Rclone remote ${DRIVENAME} after download completed, triggerd before seeding for Bittorrent task</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "move_remote" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook:<br />[move_remove] Move files to local finished folder after both download and seeding completed, then move to Rclone remote ${DRIVENAME}</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
elif [ "${RCLONE_AUTO_MODE}" = "move_remote_only" ]; then
    sed -i "s|MODE_STATUS|<br />Aria2 Event Hook:<br />[move_remote_only] Move files to Rclone remote ${DRIVENAME} after both download and seeding completed</b>|g" /.aria2allinoneworkdir/homer/assets/config.yml
fi
