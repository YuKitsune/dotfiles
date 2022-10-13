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
# Run the install script
./install.sh
```

# Reapplying configurations

Running `./configure.sh` should reapply most configurations and ensure all symlinks are created. Running `./install.sh` may be necessary after making changes to configuration files.

# Uninstalling

`./uninstall.sh` should do the trick. I don't guarantee that it works...
