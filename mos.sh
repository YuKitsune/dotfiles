
# Open Mos so that it populates the defaults
echo "🚪 Opening Mos..."
open /Applications/Mos.app

echo "⌨️ Setting defaults..."

# Hide menu bar icon
defaults write com.caldis.Mos hideStatusItem -bool true

# Restart Mos
echo "♻️ Restarting Mos.app"
killall "Mos"
open /Applications/Mos.app
