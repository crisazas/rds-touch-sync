# rds-touch-sync

Keeps the touchscreen of the **Retroid Dual Screen Add-on (RDS)** aligned with the real
display rotation, on any rooted Android device.

The add-on pairs a portrait-native panel with a touch controller that reports in
landscape. On Retroid handhelds that mismatch is compensated by a SurfaceFlinger patch
that does not exist anywhere else, so the touch ends up rotated. This module writes an
input device configuration (IDC) file for the touchscreen and keeps it in sync with the
display rotation, which makes it work in mirrored, extended and DeX modes alike.

## How it works

An IDC file in `/data/system/devices/idc/` defines how the touchscreen behaves:
device.internal = 0
touch.deviceType = touchScreen
touch.orientationAware = 1
touch.orientation = ORIENTATION_90
touch.orientation.calibration = none
touch.size.calibration = geometric
touch.pressure.calibration = none
`touch.orientationAware = 1` makes the mapper rotate coordinates along with the display.
Because the controller's raw coordinate space sits 90 degrees off the panel, that has to
be compensated with `touch.orientation`, and the value depends on the current rotation:

    θ = (90 - R) mod 360

where R is the display rotation. A fixed IDC therefore cannot keep up: `service.sh` reads
the rotation every 2 seconds, rewrites the IDC only when the value changed, and
re-enumerates the USB device so the new file gets picked up.

## Requirements

- Rooted Android (Magisk or KernelSU).
- Retroid Dual Screen Add-on.
- Android 13 or newer.

## Tested on

- Samsung Galaxy S25, stock firmware, DeX and mirrored modes.

Reports from other devices are welcome.

## Install

Install the zip from your module manager and reboot. The module takes care of itself.

## Verify
su -c 'dumpsys input | grep -A14 RetroidPocket'
`ConfigurationFile` should point at the generated IDC and `OrientationAware` should read
`true`.

## Uninstall

Disable the module in your manager, reboot, then delete the generated files:
su -c 'rm -f /data/system/devices/idc/Vendor_*.idc /data/system/devices/idc/RetroidPocket_RDS_Touchscreen.idc'

## Known limitations

- The screen blanks for a second or two on every rotation change, because the USB device
  is re-enumerated.
- The watcher runs continuously.
- If a firmware update renames the touch device, the match pattern in `gen.sh` needs
  updating.

## Credits

- [AOSP — Touch devices](https://source.android.com/docs/core/interaction/input/touch-devices)
  and `TouchInputMapper.cpp`: IDC properties and transform semantics.
- [Magisk](https://github.com/topjohnwu/Magisk): module template and `update-binary`.
- [RetroidPocket/Retroid_Dual_Screen_Add-on_Support](https://github.com/RetroidPocket/Retroid_Dual_Screen_Add-on_Support):
  documentation of the panel/touch orientation mismatch.
- [mdbell/sfrotate](https://github.com/mdbell/sfrotate): compositor-side alternative and
  related work.

## License

GPL-3.0. See [LICENSE](LICENSE).

## Disclaimer

The scripts run as root. Read the code before installing.
