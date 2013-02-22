#!/bin/bash
# Restore profile and user data given a dir containing such user data.

ADB=${ADB:-adb}
BACKUP_DIR=

echo_abort()
{
  echo "Usage: ./restore-user-data.sh <dir>"
  echo "Need to provide the backup dir containing the user data. Abort."
}

if [ ! -f "`which \"$ADB\"`" ]; then
  echo "\'adb\' tool not found, cannot update. Abort."
  exit -1
fi

if [ $# -gt 0 ]; then
  BACKUP_DIR=$1
else
  echo_abort
  exit -1
fi

if [ ! -d $BACKUP_DIR ]; then
  echo_abort
  exit -1
fi

set -x

$ADB wait-for-device
$ADB remount 1>/dev/null 2>&1

$ADB shell rm -r /data/b2g/*
$ADB shell rm -r /data/local/indexedDB/*
$ADB shell rm -r /data/local/permissions.sqlite
$ADB shell rm -r /data/local/webapps/*

$ADB push $BACKUP_DIR/data/b2g /data/b2g 1>/dev/null 2>&1
$ADB push $BACKUP_DIR/data/local/indexedDB /data/local/indexedDB 1>/dev/null 2>&1
$ADB push $BACKUP_DIR/data/local/permissions.sqlite /data/local/ 1>/dev/null 2>&1
$ADB push $BACKUP_DIR/data/local/webapps /data/local/webapps 1>/dev/null 2>&1

if [ -d $BACKUP_DIR/sdcard/media ]; then
  $ADB push $BACKUP_DIR/sdcard/media /sdcard/media 1>/dev/null 2>&1
fi

echo "Restarting B2G..."
$ADB shell stop b2g
$ADB shell start b2g
