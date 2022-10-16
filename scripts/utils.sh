#!/usr/bin/env bash

# Thank you zwbetz!
# https://zwbetz.com/check-if-an-element-exists-in-an-array-in-bash/#snippet
element_exists_in_array() {
    local usage="\
Usage:
  ${FUNCNAME[0]} <element_to_find> <array>
Sample:
  ${FUNCNAME[0]} \"dog\" \"\${animals[@]}\"
Where <element_to_find> is the element to find.
Where <array> is the array to search."

    if [[ ${#} -lt 2 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local element_to_find="${1}"
    shift
    local array=("${@}")

    for element in "${array[@]}"
    do
        if [[ "${element_to_find}" == "${element}" ]]
        then
            return 0
        fi
    done

    return 1
}

get_command() {
    command="$1"
    valid_commands=(${@:2})

    if element_exists_in_array "$command" ${valid_commands[*]}
    then
        echo $command
    else
        gum choose ${valid_commands[*]}
    fi
}

export -f get_command

print_result() {
    local usage="\
Usage:
  ${FUNCNAME[0]} \$? <success_message> <fail_message>
Sample:
  ${FUNCNAME[0]} \$? \"wget installed\" \"failed to install wget\""

    if [[ ${#} -lt 3 ]]
    then
        echo -e "${usage}" > /dev/tty
        return 1
    fi

    result_code=$1
    success=$2
    fail=$3

    if [ $result_code -eq 0 ]
    then
        echo "✅ $success" > /dev/tty
        return 0
    else
        echo "❌ $fail" > /dev/tty
        return 1
    fi
}

export -f print_result

print_result_if_failed() {
    local usage="\
Usage:
  ${FUNCNAME[0]} \$? <fail_message>
Sample:
  ${FUNCNAME[0]} \$? \"failed to install wget\""

    if [[ ${#} -lt 2 ]]
    then
        echo -e "${usage}" > /dev/tty
        return 1
    fi

    result_code=$1
    message="$2"

    if [ $result_code -ne 0 ]
    then
        echo "❌ $message" > /dev/tty
    fi
}

export -f print_result_if_failed
