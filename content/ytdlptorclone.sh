#!/bin/sh

DRIVE_NAME="$(grep ^drive-name /mnt/data/config/script.conf | cut -d= -f2-)"
DRIVE_DIR="$(grep ^drive-dir /mnt/data/config/script.conf | cut -d= -f2-)"
REMOTE_PATH="${DRIVE_NAME}:${DRIVE_DIR}"
FILEPATH=$(echo $1 | sed 's:[^/]*$::')
FILENAME=$(basename "$1")
mv "$1" "${FILEPATH}""${FILENAME}"

if [[ "${RCLONE_AUTO_MODE}" =~ "move" ]]; then
    rclone rc --user "${GLOBAL_USER}" --pass "${GLOBAL_PASSWORD}" --rc-addr=localhost:56802 operations/movefile srcFs="${FILEPATH}" srcRemote="${FILENAME}" dstFs="${REMOTE_PATH}" dstRemote="${FILENAME//+(\ )/\ }" _async=true
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
    else
        echo "[ERROR] Failed to send job to rclone: $1"
    fi
elif [[ "${RCLONE_AUTO_MODE}" =~ "copy" ]]; then
    rclone rc --user "${GLOBAL_USER}" --pass "${GLOBAL_PASSWORD}" --rc-addr=localhost:56802 operations/copyfile srcFs="${FILEPATH}" srcRemote="${FILENAME}" dstFs="${REMOTE_PATH}" dstRemote="${FILENAME}" _async=true
    EXIT_CODE=$?
    if [ ${EXIT_CODE} -eq 0 ]; then
        echo "[INFO] Successfully send job to rclone: $1 -> ${REMOTE_PATH}"
    else
        echo "[ERROR] Failed to send job to rclone: $1"
    fi
fi
