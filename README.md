
# 🦊 My Dotfiles

These are the dotfiles I use for my development environment(s).

# Setup

## 1. Install Apple Command Line Tools

These are pre-requisites for git and brew.

```sh
xcode-select --install
```

## 2. Clone the repo

```sh
git clone https://github.com/yukitsune/dotfiles
cd dotfiles
```

## 3. Install

```sh
./dotfiles.sh install
```

# Available commands

## `install`
`install` will download, install, and configure everything

## `dump`
`dump` will update the `Brewfile` and VSCode extensions file based on what's installed on the current system.
Use this if you've installed or removed brews or extensions, and want the dotfiles to reflect the changes.

## `apply`
`apply` will re-apply any configurations, ensure all symlinks are created, install brews and VSCode plugins.
This is sorta the opposite of `dump`. Use this if changes have been made elsewhere, and you want to reflect them on the current system.

## `uninstall`
`uninstall` _should_ revert as many changes as possible made by these scripts. Some things need to be undone manually.
Haven't tested this at all, so I can't gaurantee that it actually works.
