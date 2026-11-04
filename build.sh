#!/bin/sh
set -e
cd "$(dirname "$0")/module"
V=$(sed -n 's/^version=//p' module.prop)
rm -f "../rds_touch_sync-$V.zip"
chmod 755 *.sh META-INF/com/google/android/update-binary
chmod 644 module.prop META-INF/com/google/android/updater-script
zip -r9X "../rds_touch_sync-$V.zip" . > /dev/null
echo "rds_touch_sync-$V.zip"
