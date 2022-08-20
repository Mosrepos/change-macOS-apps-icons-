#parameter for the app name
app_name=$1

#add .icns extention to find the new icon
new_icon_name="${app_name}.icns"

#add .app to app_name
app_name="${app_name}.app"

#copy the old name of the icon

# Get the "Info.plist" file of the app (icon's name is written there)
info_plist="/Applications/"$app_name"/Contents/Info.plist"
nextLineIsAppIcon=0
appIcon=""

# Read every line of "Info.plist" file
while IFS= read -r line;
do
    # If this is a key of the icon's name, then make a flag
    if [[ $line == *"<key>CFBundleIconFile</key>"* ]]
    then
        nextLineIsAppIcon=1
        continue
    fi

    # Process the line with the icon's name if flag
    if [[ $nextLineIsAppIcon = 1 ]]
    then
    # Split by ">" and "<"
        appIcon="$(cut -d'>' -f2 <<< "$line")"
        appIcon="$(cut -d'<' -f1 <<< "$appIcon")"
        break
    fi
done < "$info_plist"
    
# Append ".icns" to icon's name if needed
    if [[ $appIcon != *".icns" ]]
    then
        appIcon=$appIcon".icns"
    fi

#remove the old icon
rm /Applications/$app_name/Contents/Resources/*.icns

#add the new icon
cp ~/Documents/changeIcons/icons/$new_icon_name /Applications/$app_name/Contents/Resources/$appIcon

#reload finder and dock
sudo killall Finder
sudo killall Dock

#refresh
touch /Applications/$app_name/
