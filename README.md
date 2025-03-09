
# YuKitsune's Dotfiles

These are the dotfiles I use for my development environment(s).

# What's all this then?

- My `brew` dependencies including: applications, fonts, etc.
- My macOS configuration
- My shell configuration
- My Visual Studio Code configuration

# Setup

## 1. Install Apple Command Line Tools

These are pre-requisites for git and brew.

```sh
xcode-select --install
```

## 2. Clone the repo

```sh
$DOTFILES="~/Code/github.com/YuKitsune/dotfiles"
mkdir -p $DOTFILES
git clone https://github.com/yukitsune/dotfiles $DOTFILES
cd $DOTFILES
```

## 3. Bootstrap

This ensures that all the necessary tools are installed.

```sh
./bootstrap.sh
```

## 4. Debloat

When running on Windows, consider running the debloater task.
This uninstalls a number of pre-installed aplications from Windows, including some that are re-added during the next step.

```sh
task system:debloat
```

## 5. Go!

Applies all the necessary configuration.

```sh
task apply
```

# My Setup

## Shell

I'm currently using [Ghostty](https://ghostty.org) as my terminal emulator with `zsh` as my shell of choice.
I've written a [custom plugin manager](https://github.com/yukitsune/dotfiles/main/blob/shell/zsh/.plug.zsh) to manage `zsh` plugins, which works well for me.
On top of `zsh` is [Oh My Posh](https://ohmyposh.dev) which makes everything pretty.

I have a number of pre-defined [aliases](https://github.com/yukitsune/dotfiles/main/blob/shell/zsh/.aliases.zsh) and [functions](https://github.com/yukitsune/dotfiles/main/blob/shell/zsh/.functions.zsh) to make life a little easier.

## Apps

I am using [`brew`](https://brew.sh) to install most apps for my mac. I also sync apps from the App Store with `brew` via [`mas`](https://github.com/mas-cli/mas), so the resulting Brewfile contains pretty much everything.

I also download and install packages from `.pkg` files, and git repositories using a custom scripts.
