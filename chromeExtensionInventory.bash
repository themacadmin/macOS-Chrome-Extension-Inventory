#!/bin/bash

# Create Chrome extension inventory as CSV file.

# Define variables
csvFile="chromeExtensions.csv"
csvFilePath="/Library/myOrg/Data/"

# Setting IFS Env to only use new lines as field seperator 
IFS=$'\n'

# Get current or last user
currentUser=`ls -l /dev/console | awk {' print $3 '}`
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`

if [[ "$currentUser" = "" || "$currentUser" = "root" ]]
	then userHome=`/usr/bin/dscl . -read /Users/$lastUser NFSHomeDirectory | awk -F ": " '{print $2}'`
	else userHome=`/usr/bin/dscl . -read /Users/$currentUser NFSHomeDirectory | awk -F ": " '{print $2}'`
fi

# Function to list Chrome extensions
createChromeExtList ()
{
for manifest in $(find "$userHome/Library/Application Support/Google/Chrome/Default/Extensions" -name 'manifest.json')
	do 
		name=$(cat $manifest | grep '"name":' | awk -F "\"" '{print $4}')
		if [[ `echo $name | grep "__MSG"` ]]
			then
				msgName="\"`echo $name | awk -F '__MSG_|__' '{print $2}'`\":"
				if [ -f $(dirname $manifest)/_locales/en/messages.json ]
					then reportedName=$(cat $(dirname $manifest)/_locales/en/messages.json | grep -i -A 3 "$msgName" | grep "message" | head -1 | awk -F ": " '{print $2}' | tr -d "\"")
				elif [ -f $(dirname $manifest)/_locales/en_US/messages.json ]
					then reportedName=$(cat $(dirname $manifest)/_locales/en_US/messages.json | grep -i -A 3 "$msgName" | grep "message" | head -1 | awk -F ": " '{print $2}' | tr -d "\"")
				fi
			else
				reportedName=$(cat $manifest | grep '"name":' | awk -F "\"" '{print $4}')
		fi
		version=$(cat $manifest | grep '"version":' | awk -F "\"" '{print $4}')
		extID=$(basename $(dirname $(dirname $manifest)))

		# output is...
		# Extension name,version,extensionID,user's home folder
		# e.g.
		# Google Maps,5.4.1,lneaknkopdijkpnocmklfnjbeapigfbh,/Users/jappleseed
		echo -e "$reportedName,$version,$extID,$userHome"
 done
 }

# Check for Chrome extensions directory. If it does not exist, exit.
if [ ! -d "$userHome/Library/Application Support/Google/Chrome/Default/Extensions" ]
	then
		echo "No Chrome extensions found for in $userHome"
		exit 0
fi

# Check for CSV file. If it doesn't exist, create it.
if [ ! -f $csvFilePath$csvFile ]
	then
		mkdir -p "$csvFilePath" && touch "$csvFilePath$csvFile"
fi

# for extension in `createChromeExtList`
# check for duplicate entry
# if no duplicate, append $entry to CSV file

for extension in `createChromeExtList`;do
	dupExtension=$(grep -c "$extension" "$csvFilePath$csvFile")
	if [ "$dupExtension" -eq 0 ];then
		echo "$extension" >> "$csvFilePath$csvFile"
	fi	
done

exit 0
