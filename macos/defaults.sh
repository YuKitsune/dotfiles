write_default() {

    
    defaults write $*
}

write_value() {
    domain=$1
    key=$2
    value=$3

    echo "writing $key $value"

    /usr/libexec/PlistBuddy -c "Set $key $value" $HOME/Library/Preferences/$domain.plist
}