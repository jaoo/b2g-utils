#!/bin/bash

ADB=${ADB:-adb}
TMP_DIR=/tmp/b2g-user-backup

echo_abort()
{
  echo "Need to run |./save-user-data.sh| script first. Abort."
}

if [ ! -e $TMP_DIR ]; then
  echo_abort
  exit -1
fi

$ADB wait-for-device
$ADB remount 1>/dev/null 2>&1
$ADB push $TMP_DIR/system/b2g/defaults /system/b2g/defaults 1>/dev/null 2>&1
$ADB push $TMP_DIR/data/b2g /data/b2g 1>/dev/null 2>&1
$ADB push $TMP_DIR/data/local/indexedDB /data/local/indexedDB 1>/dev/null 2>&1
$ADB push $TMP_DIR/data/local/permissions.sqlite /data/local/ 1>/dev/null 2>&1

echo Restarting B2G
$ADB shell stop b2g
$ADB shell start b2g
