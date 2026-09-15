function _install_from_git() {
    local usage="\
Usage:
    # Clone the git repo from the repo URL to the directory, or update an existing git repo at the directory.
    ${funcstack[1]} <repo-url> <dir> <ref>"

    if [[ ${#} -ne 3 ]]
    then
        echo -e "${usage}"
        return 1
    fi

    local repo_url="$1"
    local clone_dir="$2"
    local ref="$3"

    # Ensure that the directory exists
    mkdir -p $clone_dir

    # Check if the directory is a git repository
    if [ ! -d $clone_dir/.git ]; then
        # Clone the tpm repository to the directory if it doesn't exist
        echo "♻️ Cloning $repo_url"
        git clone $repo_url $clone_dir --depth 1
    else
        # Fetch the latest changes from the remote repository
        pushd $clone_dir > /dev/null
        echo "♻️ Fetching $repo_url"
        git fetch origin

        # Reset any changes made to the local repository
        git reset --hard $ref
        
        popd > /dev/null
    fi
}

_install_from_git $@
