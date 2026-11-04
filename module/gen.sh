#!/system/bin/sh
MODDIR=${0%/*}
[ -f "$MODDIR/gen.sh" ] || MODDIR=/data/adb/modules/rds_touch_sync
IDC=/data/system/devices/idc
O=${1:-ORIENTATION_90}
mkdir -p "$IDC"

gen() {
  f="$IDC/Vendor_$1_Product_$2.idc"
  cat > "$f" <<IDCEOF
device.internal = 0
touch.deviceType = touchScreen
touch.orientationAware = 1
touch.orientation = $O
touch.orientation.calibration = none
touch.size.calibration = geometric
touch.pressure.calibration = none
IDCEOF
  cp -f "$f" "$IDC/$3.idc"
  chmod 644 "$f" "$IDC/$3.idc"
}

v=""; p=""
while IFS= read -r line; do
  case "$line" in
    "I: "*)
      v=$(printf '%s' "$line" | sed -n 's/.*Vendor=\([0-9a-fA-F]*\).*/\1/p')
      p=$(printf '%s' "$line" | sed -n 's/.*Product=\([0-9a-fA-F]*\).*/\1/p')
      ;;
    "N: "*)
      case "$line" in
        *RDS*|*RetroidPocket*)
          n=$(printf '%s' "$line" | sed 's/^N: Name="//; s/"$//')
          c=$(printf '%s' "$n" | tr -c 'A-Za-z0-9_-' '_')
          [ -n "$v" ] && [ -n "$p" ] && [ -n "$c" ] && gen "$v" "$p" "$c"
          ;;
      esac
      ;;
  esac
done < /proc/bus/input/devices

restorecon -R "$IDC" 2>/dev/null
