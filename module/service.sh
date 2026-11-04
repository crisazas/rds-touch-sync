#!/system/bin/sh
MODDIR=${0%/*}
[ -f "$MODDIR/hotplug.sh" ] || MODDIR=/data/adb/modules/rds_touch_sync
sleep 10
if command -v inotifyd > /dev/null 2>&1; then
  inotifyd "$MODDIR/hotplug.sh" /dev/input:c /dev/input:d
else
  sh "$MODDIR/watch.sh"
fi
