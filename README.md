# Fake PS3 Controller Patcher for Mac OSX Sierra to Big Sur

## Description

This allows you to use fake Playstation 3 controllers on mac using bluetooth/wireless connection.

Pairing the fake PS3 controllers on mac os doesn't really work well because they are using a different identification.
This patch will make your controller mimic a real one.

## ⚠️ NO GUARANTEES TO WORK
## DISCLAIMER

The program does not overwrite or remove any files from your filesystem. This program does NOT require you to run as root
or sudo. You will need to overwrite and delete the files yourself. Instructions to do so are intentionally not included.
If you do not know how to do it, maybe you should not play with this script at all.

I AM NOT RESPONSIBLE IF YOU DELETE YOUR SYSTEM FILES WITHOUT ANY BACKUP WHATSOEVER.

## Pairing your fake PS3 Controller for the first time

With bluetooth turned on on your mac, connect the PS3 via USB. Press and hold the PS button (the middle one) for around 5 seconds.
Unplug the USB cable from your controller. It should become available in your list of bluetooth devices.
It will be something like "PLAYSTATION(R)3Conteroller-PANHAI" 

When you connect to the controller, the 4 indicator LEDs will blink rapidly at the same time. After a few seconds, the controller
will turn off.

Turn on the controller and it will connect to the mac again, this time, copy the bluetooth address to somewhere before it disconnects. 
(you can check it if you Right Click or CMD+Click on the device on the Bluetooth list)

 ![Screen Shot 2022-06-27 at 3 23 24 PM](https://user-images.githubusercontent.com/1763107/175953056-0d2c3db9-5953-4fdc-aeb3-a932dc5586d3.png)

## Patching

Clone this repository, and go to its directory in your filesystem. Run patch.sh by invoking `./patch.sh`. You will be asked to enter
the bluetooth address of the controller (the one you have taken note of earlier). 

It will copy the `com.apple.Bluetooth.plist` to the current directory and patch it with the needed information. You will then
need to put it back to `/Library/Preferences/com.apple.Bluetooth.plist`, delete the file shown by the script, read the new plist file
and restart the machine

```
Using Catalina Patch
Enter bluetooth address of controller:
dc-16-b2-f5-f2-bf
Device name is PLAYSTATION(R)3Conteroller-PANHAI. Is this correct? [y/N]
y

Done patching.
1. Place ./com.apple.Bluetooth.plist to /Library/Preferences/com.apple.Bluetooth.plist (replacing the file)
2. Remove the file /Users/kd558w/Library/Preferences/ByHost/com.apple.Bluetooth.XXXXX-XXXX-XXXXXX-XXXXX.plist
3. Run defaults read /Library/Preferences/com.apple.Bluetooth.plist
4. Then restart machine.

Backup of /Library/Preferences/com.apple.Bluetooth.plist is kept at com.apple.Bluetooth.plist.2022-07-18-19-06-10.bak
```

## Testing

When you connect your fake PS3 controller now, the 4 LED indicator should blink not as fast. They are still lighting up at the same time (no player num in mac)

## Couple of requirements

It is assumed that you have a couple of files in the following directories:

1. `/usr/bin/plutil`
2. `/usr/libexec/PlistBuddy`

