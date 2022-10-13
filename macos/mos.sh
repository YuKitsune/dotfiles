
# Open Mos so that it populates the defaults
open /Applications/Mos.app

# Hide menu bar icon
defaults write com.caldis.Mos hideStatusItem -bool true

# Restart Mos
killall "Mos"
open /Applications/Mos.app
