# Changelog

## 1.2.3

- Fall back to a plain polling loop when `inotifyd` is unavailable.
- Document the `inotifyd` requirement.

## 1.2.2

- Start the watcher on hotplug instead of polling permanently.
- Stop polling while the add-on is unplugged.
- Generate the IDC if it is missing.

## 1.2

- Sync touch orientation with the display rotation.
- Works in mirrored, extended and DeX modes.
