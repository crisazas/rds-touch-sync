---
name: Bug report
about: Report a device or mode where the module does not work
title: "[bug] "
labels: bug
---

## Device

<!-- Model, e.g. Samsung Galaxy S25 -->

## Environment

- Android version:
- ROM / firmware:
- Root manager and version (Magisk / KernelSU):

## Display mode

<!-- mirrored / extended / DeX -->

## Behaviour

<!-- What happens, and which corner responds to which touch -->

## Diagnostics

Output of:

~~~sh
su -c 'dumpsys input | grep -A14 RetroidPocket'
~~~

~~~sh
su -c 'dumpsys display | grep -m1 Lontium'
~~~

~~~sh
su -c 'cat /data/system/devices/idc/Vendor_*.idc'
~~~
