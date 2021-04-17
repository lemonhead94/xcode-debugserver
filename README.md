# xcode-debugserver

This will create a Developer Disk Image for a specified iOS version and sign it using ldid with the provided entitlements.xml.

Prerequirements:
brew install ldid

curl "https://raw.githubusercontent.com/lemonhead94/xcode-debugserver/main/createDebugServer.sh" | bash -s IOS_VERSION OUTPUT_DIRECTORY

Example:
curl "https://raw.githubusercontent.com/lemonhead94/xcode-debugserver/main/createDebugServer.sh" | bash -s 14.3 ~/Desktop
