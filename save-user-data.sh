#!/bin/bash

ADB=${ADB:-adb}
TMP_DIR=/tmp/b2g-user-backup

rm -rf $TMP_DIR

mkdir -p $TMP_DIR/system/b2g/defaults
mkdir -p $TMP_DIR/data/local/indexedDB
mkdir -p $TMP_DIR/data/b2g/

$ADB wait-for-device
$ADB pull /system/b2g/defaults $TMP_DIR/system/b2g/defaults/ 1>/dev/null 2>&1
$ADB pull /data/b2g $TMP_DIR/data/b2g/ 1>/dev/null 2>&1
$ADB pull /data/local/indexedDB $TMP_DIR/data/local/indexedDB/ 1>/dev/null 2>&1
$ADB pull /data/local/permissions.sqlite $TMP_DIR/data/local/ 1>/dev/null 2>&1
