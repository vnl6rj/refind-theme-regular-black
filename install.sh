#!/bin/bash

# An installer for refind-theme-regular-black by vnl6rj, forked from Munlik

#Check if root
[[ $EUID -ne 0 ]] && echo "This script must be run as root." && exit 1

clear

#Clone the theme
echo -n "Downloading rEFInd theme Regular to $PWD"
git clone https://github.com/vnl6rj/refind-theme-regular-black.git &> /dev/null
echo " - [DONE]"

#Useful formatting tags
bold=$(tput bold)
normal=$(tput sgr0)

#Set install path
echo "Enter rEFInd install location"
read -e -p "Default - ${bold}/boot/efi/EFI/refind/${normal}: " location
if test -z "$location";
then
    location="/boot/efi/EFI/refind/"
fi
if test "${location: -1}" != "/"
then
    location="$location/"
fi

#Set icon size
echo "Pick an icon size: (larger icons look better on bigger and denser displays)"
read -p "${bold}1: small (128px-48px)${normal}, 2: medium (256px-96px), 3: large (384px-144px), 4: extra-large (512px-192px): " size_select
if test -z "$size_select";
then
    size_select=1
fi
case "$size_select" in
    1)
        size_big="128"
        size_small="48"
        ;;
    2)
        size_big="256"
        size_small="96"
        ;;
    3)
        size_big="384"
        size_small="144"
        ;;
    4)
        size_big="512"
        size_small="192"
        ;;
    *)
        echo "Incorrect choice. Exiting."
        exit 1
        ;;
esac
echo
echo "Selected size - ${bold}big icons: $size_big px, small icons: $size_small px${normal}"
echo

#Uncomment relevant lines from src/theme.conf
echo -n "Generating theme file theme.conf"
cd refind-theme-regular-black
cp src/theme.conf theme.conf
sed -i "s/#icons_dir refind-theme-regular-black\/icons\/$size_big-$size_small/icons_dir refind-theme-regular-black\/icons\/$size_big-$size_small/" theme.conf
sed -i "s/#big_icon_size $size_big/big_icon_size $size_big/" theme.conf
sed -i "s/#small_icon_size $size_small/small_icon_size $size_small/" theme.conf
sed -i "s/#banner refind-theme-regular-black\/icons\/$size_big-$size_small\/bg.png/banner refind-theme-regular-black\/icons\/$size_big-$size_small\/bg.png/" theme.conf
sed -i "s/#selection_big refind-theme-regular-black\/icons\/$size_big-$size_small\/selection-big.png/selection_big refind-theme-regular-black\/icons\/$size_big-$size_small\/selection-big.png/" theme.conf
sed -i "s/#selection_small refind-theme-regular-black\/icons\/$size_big-$size_small\/selection-small.png/selection_small refind-theme-regular-black\/icons\/$size_big-$size_small\/selection-small.png/" theme.conf
cd ..
echo " - [DONE]"

#Clean up
echo -n "Removing unused directories"
rm -rf refind-theme-regular-black/{src,.git}
rm -rf refind-theme-regular-black/install.sh
echo " - [DONE]"

#Remove previous installs
echo -n "Deleting older installed versions (if any)"
rm -rf "$location"{regular-theme,refind-theme-regular-black}
echo " - [DONE]"

#Copy theme setup folders
echo -n "Copying theme to $location"
cp -r refind-theme-regular-black "$location"
echo " - [DONE]"

#Edit refind.conf - remove older themes
echo -n "Removing old themes from refind.conf"
echo
echo
read -p "Do you have a secondary config file to preserve? Default: N (y/${bold}N${normal}): " config_confirm
if test -z "$config_confirm";
then
    config_confirm="n"
fi
case "$config_confirm" in
    y|Y)
        read -p "Enter the name of the config file to be preserved in full eg: manual.conf: " configname
        # Checking for enter key. If so it has the same effect having no files to preserve.
        if [[ $configname == "" ]]; then
	configname='^#'
	fi
        #Excludes line with entered config file then ^\s*include matches lines starting with any nuber of spaces and then include.
        sed --in-place=".bak" "/$configname/! s/^\s*include/# (disabled) include/" "$location"refind.conf
        ;;
    n|N)
        # ^\s*include matches lines starting with any nuber of spaces and then include.
        sed --in-place=".bak" 's/^\s*include/# (disabled) include/' "$location"refind.conf
        ;;
    *)
        ;;
esac
echo " - [DONE]"

#Edit refind.conf - add new theme
echo -n "Updating refind.conf"
echo "
# Load rEFInd theme Regular
include refind-theme-regular-black/theme.conf" | tee -a "$location"refind.conf &> /dev/null
echo " - [DONE]"

#Clean up - remove download
read -p "Delete download? (${bold}Y${normal}/n): " del_confirm
if test -z "$del_confirm";
then
    del_confirm="y"
fi
case "$del_confirm" in
    y|Y)
        echo -n "Deleting download"
        rm -r refind-theme-regular-black
        echo " - [DONE]"
        ;;
    *)
        ;;
esac

echo "Thank you for installing rEFInd theme Regular."
echo "NOTE: If you're not getting your full resolution or have color issues then try disabling the CSM in your UEFI settings."
