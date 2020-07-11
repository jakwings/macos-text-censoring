#!/bin/sh

set -e -x

country="$(defaults read /Library/Preferences/.GlobalPreferences.plist Country)"
languages="$(defaults read -g AppleLanguages)"
locale="$(defaults read -g AppleLocale)"

plist='/Library/Preferences/.GlobalPreferences.plist'

defaults delete -g Country 2> /dev/null || true

if [ "${country}" = CN ]; then
  #sudo defaults write "${plist}" Country TW
  sudo defaults write "${plist}" Country US
else
  sudo defaults write "${plist}" Country "${country:-US}"
fi

sudo defaults write "${plist}" AppleLanguages "${languages:-(en)}"
sudo defaults write "${plist}" AppleLocale "${locale:-en_US_POSIX}"

{
  sudo defaults delete "${plist}" com.apple.AppleModemSettingTool.LastCountryCode
  sudo defaults delete "${plist}" com.apple.TimeZonePref.Last_Selected_City
} 2> /dev/null || true

sudo atsutil databases -remove
sudo atsutil server -shutdown
atsutil server -ping
