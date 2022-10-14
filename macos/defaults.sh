write_default() {
    domain=$1
    key=$2
    type=$3
    value=$4

    emoji="📝"
    if [ -n "$default_command_prefix" ]
    then
        emoji="$default_command_prefix 📝"
    fi

    echo "$emoji [$domain] $key $value" > /dev/tty
    defaults write $domain "$key" $type $value
}
