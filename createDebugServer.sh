#!/bin/bash
iOS_VERSION="$1"
OUTPUT_DIRECTORY=$2

TEMP_DIR=$(mktemp -d)
ENTITLEMENTS="$TEMP_DIR/entitlements.xml"
VOLUMES="/Volumes/DeveloperDiskImage"
XCODE="/Applications/Xcode.app"

wget "https://raw.githubusercontent.com/lemonhead94/xcode-debugserver/main/entitlements.xml" -P $TEMP_DIR
cp $XCODE/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/"$iOS_VERSION"/DeveloperDiskImage.dmg $TEMP_DIR
hdiutil attach -owners on $TEMP_DIR/DeveloperDiskImage.dmg -shadow
sleep 2
cp $VOLUMES/usr/bin/debugserver $TEMP_DIR

# codesign the debugserver
ldid -S$ENTITLEMENTS $TEMP_DIR/debugserver

# remove all files except usr/bin
sudo -- sh -c "find $VOLUMES -mindepth 1 -maxdepth 1 -type d -not -name usr -exec rm -rf '{}' \;"
sudo -- sh -c "find $VOLUMES/usr -mindepth 1 -maxdepth 1 -type d -not -name bin -exec rm -rf '{}' \;"
sudo -- sh -c "rm -f $VOLUMES/usr/bin/*"

# create ddi.dmg
cp $TEMP_DIR/debugserver $VOLUMES/usr/bin/
hdiutil unmount $VOLUMES
rm $TEMP_DIR/DeveloperDiskImage.dmg.shadow
hdiutil convert -format UDZO -o $OUTPUT_DIRECTORY/ddi-"$iOS_VERSION".dmg $TEMP_DIR/DeveloperDiskImage.dmg -shadow

# remove leftover files
rm -rf $TEMP_DIR
