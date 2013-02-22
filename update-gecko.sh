#!/bin/bash

ADB=${ADB:-adb}

if [ ! -f "`which \"$ADB\"`" ]; then
  echo "adb tool not found, cannot update. Abort."
  exit -1
fi

echo_abort()
{
  echo "Need to provide b2g-XX.X.en-US.android-arm.tar.gz file. Abort."
}

run_adb()
{
  $ADB $@
}

if [ $# -eq 0 ]; then
  echo_abort
  exit -1
fi

# Delete files in the device's /system/b2g that aren't in
# $GECKO_OBJDIR/dist/b2g.
#
# We do this for general cleanliness, but also because b2g.sh determines
# whether to use DMD by looking for the presence of libdmd.so in /system/b2g.
# If we switch from a DMD to a non-DMD build and then |flash.sh gecko|, we want
# to disable DMD, so we have to delete libdmd.so.
#
# Note that we do not delete *folders* in /system/b2g.  This is intentional,
# because some user data is stored under /system/b2g (e.g. prefs), but it seems
# to be stored only inside directories.
delete_extra_gecko_files_on_device()
{
	files_to_remove="$(cat <(ls "b2g") <(run_adb shell "ls /system/b2g" | tr -d '\r') | sort | uniq -u)"
	if [[ "$files_to_remove" != "" ]]; then
		# We expect errors from the call to rm below under two circumstances:
		#
		#  - We ask rm to remove a directory (per above, we don't
		#    actually want to remove directories, so rm is doing the
		#    right thing by not removing dirs)
		#
		#  - We ask rm to remove a file which isn't on the device (if
		#    you squint at files_to_remove, you'll see that it will
		#    contain files which are on the host but not on the device;
		#    obviously we can't remove those files from the device).

		run_adb shell "cd /system/b2g && rm $files_to_remove" > /dev/null
	fi
	return 0
}

tar xzf $1 &&
run_adb remount &&
delete_extra_gecko_files_on_device &&
run_adb push b2g /system/b2g &&
echo Restarting B2G &&
run_adb shell stop b2g &&
run_adb shell start b2g
