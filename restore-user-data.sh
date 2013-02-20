#!/bin/bash

ADB=${ADB:-adb}
TMP_DIR=/tmp/b2g-user-data-backup

echo_abort()
{
  echo "Need to run |./backup-user-data.sh| script first. Abort."
}

if [ ! -e $TMP_DIR ]; then
  echo_abort
  exit -1
fi

$ADB wait-for-device
$ADB remount 1>/dev/null 2>&1

$ADB shell rm -r /data/b2g 1>/dev/null 2>&1
$ADB shell rm -r /data/local/indexedDB 1>/dev/null 2>&1
$ADB shell rm -r /data/local/permissions.sqlite 1>/dev/null 2>&1
#$ADB shell rm -r /data/local/webapps 1>/dev/null 2>&1

$ADB push $TMP_DIR/data/b2g /data/b2g 1>/dev/null 2>&1
$ADB push $TMP_DIR/data/local/indexedDB /data/local/indexedDB 1>/dev/null 2>&1
$ADB push $TMP_DIR/data/local/permissions.sqlite /data/local/ 1>/dev/null 2>&1
#$ADB push $TMP_DIR/data/local/webapps /data/local/ 1>/dev/null 2>&1

#if [ -e $TMP_DIR/media ]; then
#  $ADB push $TMP_DIR/media /sdcard/ 1>/dev/null 2>&1
#fi


echo Restarting B2G
$ADB shell stop b2g
$ADB shell start b2g
