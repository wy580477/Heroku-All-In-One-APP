#!/bin/sh

DRIVE_NAME="$(grep ^drive-name /mnt/config/script.conf | cut -d= -f2-)"
DRIVE_DIR="$(grep ^drive-dir /mnt/config/script.conf | cut -d= -f2-)"
REMOTE_PATH="${DRIVE_NAME}:${DRIVE_DIR}"
FILEPATH=$(echo $1 | sed 's:[^/]*$::')
FILENAME=$(echo $1 | sed 's:/.*/::')

if [[ "${RCLONE_AUTO_MODE}" =~ "move" ]]; then
    curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${FILEPATH}"'","srcRemote":"'"${FILENAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${FILENAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/movefile'
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
    else
        echo "[ERROR] Failed to send job to rclone: $1"
    fi
elif [[ "${RCLONE_AUTO_MODE}" =~ "copy" ]]; then
    curl -s -S -u ${USER}:${PASSWORD} -H "Content-Type: application/json" -f -X POST -d '{"srcFs":"'"${FILEPATH}"'","srcRemote":"'"${FILENAME}"'","dstFs":"'"${REMOTE_PATH}"'","dstRemote":"'"${FILENAME}"'","_async":"true"}' ''${RCLONE_ADDR}'/operations/copyfile'
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
    else
        echo "[ERROR] Failed to send job to rclone: $1"
    fi
fi
