#!/bin/bash
# Backup profile and user data.

ADB=${ADB:-adb}
TIME=`date +"%Y-%m-%d_%H%M%S"`
TMP_DIR=/tmp/b2g-user-data-backup-$TIME

if [ ! -f "`which \"$ADB\"`" ]; then
  echo "\'adb\' tool not found, cannot update. Abort."
  exit -1
fi

set -x

mkdir -p $TMP_DIR/data/b2g
mkdir -p $TMP_DIR/data/local/indexedDB
mkdir -p $TMP_DIR/data/local/webapps

$ADB wait-for-device
$ADB pull /data/b2g $TMP_DIR/data/b2g/ 1>/dev/null 2>&1
$ADB pull /data/local/indexedDB $TMP_DIR/data/local/indexedDB/ 1>/dev/null 2>&1
$ADB pull /data/local/permissions.sqlite $TMP_DIR/data/local/ 1>/dev/null 2>&1
$ADB pull /data/local/webapps $TMP_DIR/data/local/webapps/ 1>/dev/null 2>&1

MEDIA_DIR=$(adb shell ls /sdcard/ | grep media)
if [ $MEDIA_DIR ]; then
  mkdir -p $TMP_DIR/sdcard/media
  $ADB pull /sdcard/media $TMP_DIR/sdcard/media/ 1>/dev/null 2>&1
fi

echo "Done, backup saved at $TMP_DIR"
