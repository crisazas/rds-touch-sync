#!/system/bin/sh
MODDIR=${0%/*}
[ -f "$MODDIR/gen.sh" ] || MODDIR=/data/adb/modules/rds_touch_sync
i=0
while [ $i -lt 10 ]; do
  sh "$MODDIR/gen.sh"
  i=$((i+1))
  sleep 1
done
