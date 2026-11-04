#!/system/bin/sh
MODDIR=${0%/*}
[ -f "$MODDIR/hotplug.sh" ] || MODDIR=/data/adb/modules/rds_touch_sync
sleep 10
inotifyd "$MODDIR/hotplug.sh" /dev/input:c /dev/input:d
