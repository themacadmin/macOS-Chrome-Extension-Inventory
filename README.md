# macOS-Chrome-Extension-Inventory
Chrome Extension Inventory for macOS

Collects inventory of Chrome extensions in /Library/myOrg/Data/chromeExtensions.csv

Format:

*Extension name,version,extensionID,user's home folder*

e.g.

*Google Maps,5.4.1,lneaknkopdijkpnocmklfnjbeapigfbh,/Users/jappleseed*

## Can easily create extension attributes and/or reports...

### Get version when ID is known...

`awk -F "," '/lneaknkopdijkpnocmklfnjbeapigfbh/{print $2}' /Library/myOrg/Data/chromeExtensions.csv`

### Get ID when name is known...

`awk -F "," '/Google Maps/{print $3}' /Library/myOrg/Data/chromeExtensions.csv`

### Get names of all extensions for user jappleseed

`awk -F "," '/jappleseed/{print $1}' /Library/myOrg/Data/chromeExtensions.csv`

## com.themacadmin.chromeExtensionInventory.plist
LaunchAgent, runs script when user's Chrome extension directory is changed.

## chromeExtensionInventory.bash
Collects inventory
