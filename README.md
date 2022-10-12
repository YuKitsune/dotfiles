# Steps to bootstrap a new Mac

## 1. Install Apple Command Line Tools

These are pre-requisites for git and brew.

```sh
xcode-select --install
```

## 2. Install Brew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 3. Clone the repo

```sh
git clone https://github.com/yukitsune/dotfiles <wherever you wanna store the repo>
```

## 4. Install

```sh
# Mark all scripts as executable 
find . -type f -name "*.sh" | xargs chmod +x

# Run the install script
./install.sh
```

# Reapplying configurations

Running `./configure.sh` should reapply most configurations and ensure all symlinks are created. Running `./install.sh` may be necessary in some cases.

# Uninstalling

`./uninstall.sh` should do the trick. I don't guarantee that it works...