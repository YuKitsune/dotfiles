#!/usr/bin/env zsh

# Lightweight plugin manager for ZSH

export ZSH_PLUGINS="$HOME/.zsh_plugins"

_install() {
    local usage="\
Usage:
    ${funcstack[1]} <url>
Sample:
    ${funcstack[1]} \"https://github.com/marlonrichert/zsh-autocomplete.git\""

    if [[ ${#} -lt 1 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local url="$1"
    local repo_name=$(basename $url .git)
    local repo_path="$ZSH_PLUGINS/$repo_name"

    echo "📡 Cloning $url"
    git clone --depth=1 -- "$url" $repo_path
}

_update() {
    local usage="\
Usage:
    ${funcstack[1]} <plugin>
Sample:
    ${funcstack[1]} \"zsh-autocomplete\""

    if [[ ${#} -lt 1 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local plugin="$1"

    pushd $ZSH_PLUGINS/$plugin > /dev/null

    echo "♻️ Pulling $url"
    git pull --depth 1
    git gc --prune=all

    popd > /dev/null
}

_uninstall() {
    local usage="\
Usage:
    ${funcstack[1]} <plugin>
Sample:
    ${funcstack[1]} \"zsh-autocomplete\""

    if [[ ${#} -lt 1 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local plugin="$1"
    local path="$ZSH_PLUGINS/$plugin"

    echo "🗑 Deleting $path"
    rm -rf $path
    if [ $? -eq 0 ]
    then
        echo "✅ $plugin has been removed. Don't forget to remove it from your .zshrc file."
    else
        echo "❌ failed to remove $plugin"
    fi
}

_plugin() {
    local usage="\
Usage:
    ${funcstack[1]} <url> <source_file>
Sample:
    ${funcstack[1]} \"https://github.com/marlonrichert/zsh-autocomplete.git\" \"zsh-autocomplete.plugin.zsh\""

    if [[ ${#} -lt 2 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local url="$1"
    local source_file="$2"
    local plugin=$(basename $url .git)
    local plugin_path="$ZSH_PLUGINS/$plugin"
    local source_path="$plugin_path/$source_file"

    # Download the plugin if it doesn't exist
    if [ ! -e "$plugin_path" ]
    then
        _install "$url"
        if [ $? -ne 0 ]
        then
            echo "❌ Failed to install $url"
            return 1
        fi
    fi

    # Todo: Check for updates

    source "$source_path"
}

plugin() {
    local usage="\
Usage:    
    # For use from the command line
    ${funcstack[1]} <command>

    # Install or source a plugin, for use within a .zshrc file
    ${funcstack[1]} <url> <source_file>

Commands:
    install
    update
    uninstall"

    if [[ ${#} -lt 1 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local maybe_command="$1"
    if [ "$maybe_command" = "install" ]
    then
        _install ${@:2}
        return $?
    elif [ "$maybe_command" = "update" ]
    then
        _update ${@:2}
        return $?
    elif [ "$maybe_command" = "uninstall" ]
    then
        _uninstall ${@:2}
        return $?
    elif [[ ${#} -eq 2 ]]
    then
        _plugin ${@:1}
        return $?
    fi

    echo -e "${usage}"
    return 1
}
