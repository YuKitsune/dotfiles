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

ensure_onboarding_completed() {
    local usage="\
Usage:
  ${FUNCNAME[0]} <domain> <name> <path>
Sample:
  ${FUNCNAME[0]} \"com.caldis.Mos\" \"Mos\" \"/Applications/Mos.app\""

    if [[ ${#} -lt 3 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    domain=$1
    name=$2
    path=$3

    emoji=""
    if [ -n "$default_command_prefix" ]
    then
        emoji=$default_command_prefix
    fi

    defaults read $domain > /dev/null

    if [ $? == 1 ]
    then
        gum confirm --affirmative="Open" --negative="Skip" "$name has not yet been run. $name has some onboarding steps which may need to be completed before the defaults can be set. Do you wish to open $name now?"

        if [ $? == 0 ]
        then
            open $path
            gum confirm --affirmative="Continue" --negative="Cancel" "$name has been opened, select \"Continue\" once onboarding has been completed."
            if [ $? == 0 ]
            then
                echo "$emoji ⏭ Skipping $name configuration"
                return 0
            fi
        fi

        echo "$emoji ⏭ Skipping $name configuration"
        return 1
    fi

    return 0
}

kill_process() {
    name=$1

    emoji=""
    if [ -n "$default_command_prefix" ]
    then
        emoji=$default_command_prefix
    fi

    if [ `pgrep $1` ]
    then
        echo "$emoji 🔫 Killing $name" > /dev/tty
        killall "$name"
    fi
}
