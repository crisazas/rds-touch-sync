#!/system/bin/sh
MODDIR=${0%/*}
[ -f "$MODDIR/gen.sh" ] || MODDIR=/data/adb/modules/rds_touch_sync
IDC_DIR=/data/system/devices/idc

idcpath() {
  ls "$IDC_DIR"/Vendor_*.idc 2>/dev/null | head -n1
}

vendor() {
  f=$(idcpath)
  if [ -n "$f" ]; then
    basename "$f" | sed -n 's/^Vendor_\([0-9a-fA-F]*\)_.*/\1/p'
  else
    printf '222a'
  fi
}

usbdev() {
  for d in /sys/bus/usb/devices/*; do
    [ -e "$d/idVendor" ] || continue
    read -r iv < "$d/idVendor" 2>/dev/null
    [ "$iv" = "$1" ] && basename "$d" && return
  done
}

present() {
  for f in /sys/bus/usb/devices/*/idVendor; do
    [ -e "$f" ] || continue
    read -r iv < "$f" 2>/dev/null
    [ "$iv" = "$1" ] && return 0
  done
  return 1
}

while true; do
  IDC=$(idcpath)
  if [ -z "$IDC" ]; then
    sh "$MODDIR/gen.sh"
    IDC=$(idcpath)
    [ -z "$IDC" ] && exit 0
  fi
  V=$(vendor)
  present "$V" || exit 0
  rot=$(timeout 5 dumpsys display 2>/dev/null | grep -m1 Lontium | sed -n 's/.* rotation \([0-9]*\),.*/\1/p')
  if [ -n "$rot" ]; then
    want=$(( (90 - rot + 360) % 360 ))
    case "$want" in
      0)   o=ORIENTATION_0 ;;
      90)  o=ORIENTATION_90 ;;
      180) o=ORIENTATION_180 ;;
      270) o=ORIENTATION_270 ;;
    esac
    have=$(sed -n 's/^touch\.orientation = //p' "$IDC" 2>/dev/null)
    if [ "$o" != "$have" ]; then
      sh "$MODDIR/gen.sh" "$o"
      d=$(usbdev "$V")
      if [ -n "$d" ]; then
        echo -n "$d" > /sys/bus/usb/drivers/usb/unbind
        sleep 1
        echo -n "$d" > /sys/bus/usb/drivers/usb/bind
      fi
    fi
  fi
  sleep 2
done
