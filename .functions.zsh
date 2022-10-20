
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

qc() {
    git add .
    git status
    commit_message=$(gum input --placeholder "Commit message")
    git commit -m "$commit_message"
    gum spin --title="Pushing" --show-output -- git push
}
