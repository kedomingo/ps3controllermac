#!/bin/bash

# Apple minor version e.g. 11.6 for big sur (not patch version like 11.6.6)
version=`sw_vers -productVersion | sed -re 's/\.[0-9]+$//g'`
if [[ $version < 10.12 ]]; then
  echo "Unsupported version $version"
  exit
elif [[ $version < 10.14 ]]; then
  echo "Using High Sierra Patch"
else
  echo "Using Catalina Patch"
fi

backupFile=com.apple.Bluetooth.plist.`date '+%Y-%m-%d-%H-%M-%S'`.bak
cp /Library/Preferences/com.apple.Bluetooth.plist .
cp /Library/Preferences/com.apple.Bluetooth.plist "./$backupFile"

if [ ! -f "com.apple.Bluetooth.plist" ]; then
    echo "Could not copy com.apple.Bluetooth.plist to the current directory."
    exit
elif [ ! -f "/usr/bin/plutil" ]; then
    echo "Could not find plutil at /usr/bin/plutil"
    exit
elif [ ! -f "/usr/libexec/PlistBuddy" ]; then
    echo "Could not find PlistBuddy at /usr/libexec/PlistBuddy"
    exit
fi

echo "Enter bluetooth address of controller: "
read address

deviceName=`/usr/libexec/PlistBuddy -c "Print DeviceCache:$address:Name" com.apple.Bluetooth.plist`
echo "Device name is $deviceName. Is this correct? [y/N]"
read response

if [ $response != "y" ]; then
    exit
fi

if [[ $version < 10.14 ]]; then
  # echo "/usr/libexec/PlistBuddy -c \"Import DeviceCache:$address:Services sierraps3.bin\" com.apple.Bluetooth.plist"
  /usr/libexec/PlistBuddy -c "Import DeviceCache:$address:Services sierraps3.bin" com.apple.Bluetooth.plist
else
  # echo "/usr/libexec/PlistBuddy -c \"Import DeviceCache:$address:Services mojaveps3.bin\" com.apple.Bluetooth.plist"
  /usr/libexec/PlistBuddy -c "Import DeviceCache:$address:Services mojaveps3.bin" com.apple.Bluetooth.plist
fi

currentDate=`date '+%a %b %d %H:%M:%S %Z %Y'` # The formatting is the only accepted format https://github.com/darlinghq/darling/blob/master/src/PlistBuddy/PlistBuddy.c#L765
# echo "/usr/libexec/PlistBuddy -c \"Add DeviceCache:$address:LastServiceUpdate date '$currentDate'\" com.apple.Bluetooth.plist"
/usr/libexec/PlistBuddy -c "Add DeviceCache:$address:LastServiceUpdate date '$currentDate'" com.apple.Bluetooth.plist

# echo "/usr/libexec/PlistBuddy -c \"Set DeviceCache:$address:ClassOfDevice 1288\" com.apple.Bluetooth.plist"
/usr/libexec/PlistBuddy -c "Set DeviceCache:$address:ClassOfDevice 1288" com.apple.Bluetooth.plist

# echo "plutil -convert binary1 com.apple.Bluetooth.plist"
plutil -convert binary1 com.apple.Bluetooth.plist

echo ""
echo "Done patching."
echo "1. Place ./com.apple.Bluetooth.plist to /Library/Preferences/com.apple.Bluetooth.plist (replacing the file)"

for file in ~/Library/Preferences/ByHost/com.apple.Bluetooth.*.plist ; do
  if [ -e "$file" ] ; then
     echo "2. Remove the file $file"
  fi
done

echo "3. Run defaults read /Library/Preferences/com.apple.Bluetooth.plist"
echo "4. Then restart machine."
echo ""
echo "Backup of /Library/Preferences/com.apple.Bluetooth.plist is kept at $backupFile"
