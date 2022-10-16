# Steps to bootstrap a new Mac

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

## `update`
`update` will update the Brewfile and VSCode extensions based on what's installed on the current system.

## `sync`
`sync` will re-apply any configurations, ensure all symlinks are created, re-sync brews and VSCode plugins.

## `uninstall`
`uninstall` _should_ revert as many changes as possible made by these scripts. Some things need to be undone manually.
