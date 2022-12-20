
# Todo: Move this somewhere else so we don't mess up the other functions
check-dotfile-updates() {
    pushd $HOME/Developer/github.com/yukitsune/dotfiles > /dev/null

	temp_file=$(mktemp)
	gum spin --title="Checking for updated to dotfiles..." -- git fetch --dry-run > $temp_file
    output=$(cat $temp_file)

    if [ -n "$output" ]
    then
        gum confirm "🆕 Updated dotfiles available! Do you want to clone and update now?"
        if [ $? -ne 0 ]
        then
            return 0
        fi

        git pull
        if [ $? -ne 0 ]
        then
            echo "❌ Failed to pull dotfiles"
            return 1
        fi

        sh ./dotfiles.sh sync
        if [ $? -ne 0 ]
        then
            echo "❌ Failed to sync dotfiles"
            return 1
        fi

        gum confirm "✅ Dotfiles updated and synced! Do you want to restart your terminal now?"
        if [ $? -eq 0 ]
        then
            exit 0
        fi
    fi

    popd > /dev/null
}

# Reads a value from a .env file
env() {

	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "Usage:"
		echo "	$0 <path_to_env_file> <variable_name>"
		return 1
	fi

	cat $1 | grep $2 | head -1 | awk -F'=' '{print $2}'
}

# Git
## Quick commit: 
## 1. Stage all changes
## 2. Print the status for a sanity check
## 3. Commit with a message
## 4. Push to the remote
qc() {
    git add .
    git status
    commit_message=$(gum input --placeholder "Commit message")
    git commit -m "$commit_message"

    gum confirm "Force push?"
    if [ $? -eq 0 ]
    then
        gum spin --title="Pushing" --show-output -- git push
    else
	gum spin --title="Pushing" --show-output -- git push -f
    fi
}

## Prints the currently checked out git ref (Branch, tag, or commit hash)
ref() {
	branch_name=$(git symbolic-ref -q --short HEAD 2> /dev/null)
	if [ $? -eq 0 ]; then
		echo $branch_name
		return 0
	fi

	tag_name=$(git describe --tags --exact-match 2> /dev/null)
	if [ $? -eq 0 ]; then
		echo $tag_name
		return 0
	fi

	hash=$(git rev-parse HEAD)
	echo $hash
}

# Kubectl
## Change context
kc() {
    local context=$(kubectl config get-contexts | awk '{print $2}' | tail +2 | gum choose)
    kubectl config use-context $context
}

## Change namespace
kn() {
    # List all namespaces, take the first column, skip the header, feed them to gum
    local namespace=$(kubectl get namespace | awk '{print $1}' | tail +2 | gum choose)
    kubectl config set-context --current --namespace=$namespace
}
