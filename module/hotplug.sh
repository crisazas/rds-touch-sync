#!/system/bin/sh
MODDIR=${0%/*}
[ -f "$MODDIR/watch.sh" ] || MODDIR=/data/adb/modules/rds_touch_sync
case "$1" in
  *c*) [ -f /data/adb/rds_watch.pid ] || { sh "$MODDIR/watch.sh" & echo $! > /data/adb/rds_watch.pid; } ;;
  *d*) pkill -f watch.sh 2>/dev/null; rm -f /data/adb/rds_watch.pid ;;
esac
