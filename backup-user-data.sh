#!/bin/bash

ADB=${ADB:-adb}
TMP_DIR=/tmp/b2g-user-data-backup

rm -rf $TMP_DIR

mkdir -p $TMP_DIR/data/b2g/
mkdir -p $TMP_DIR/data/local/indexedDB
mkdir -p $TMP_DIR/data/local/webapps

$ADB wait-for-device
$ADB pull /data/b2g $TMP_DIR/data/b2g/ 1>/dev/null 2>&1
$ADB pull /data/local/indexedDB $TMP_DIR/data/local/indexedDB/ 1>/dev/null 2>&1
$ADB pull /data/local/permissions.sqlite $TMP_DIR/data/local/ 1>/dev/null 2>&1
$ADB pull /data/local/webapps $TMP_DIR/data/local/webapps/ 1>/dev/null 2>&1

MEDIA_DIR=$(adb shell ls /sdcard/ | grep media)
if [ $MEDIA_DIR ]; then
  mkdir -p $TMP_DIR/sdcard/media/
  $ADB pull /sdcard/media $TMP_DIR/sdcard/media/ 1>/dev/null 2>&1
fi
