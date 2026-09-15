
# YuKitsune's Dotfiles

These are the dotfiles I use for my development environments.

## What's all this then?

- My `brew` dependencies including: applications, fonts, etc.
- My macOS configuration
- My shell configuration
- My Visual Studio Code configuration

## Setup

```sh
# Pre-requisite for git and brew
xcode-select --install

# Clone the repo
DOTFILES="$HOME/Code/github.com/YuKitsune/dotfiles"
mkdir -p $DOTFILES
git clone https://github.com/yukitsune/dotfiles $DOTFILES
cd $DOTFILES

# Install brew, gum, and plz
./bootstrap-macos.sh
# or
./bootstrap-ubuntu.sh
```

Open a new terminal window (or `source ~/.zprofile` on macOS / `source ~/.bashrc` on Ubuntu) so `brew`, `gum`, and `plz` are on your `PATH`.

```sh
# Windows only: uninstall bloatware before the next step re-adds some of it
plz system debloat

# Install everything and apply all configuration
plz apply
```

You may need to reload the shell after running this.

## SSH Key Import

I store my SSH keys on an external USB flash drive. When I set up a new machine, I copy them from the flash drive onto the machine.
Run the following command to automatically import SSH keys from the flash drive once it's been connected.

```sh
plz import-ssh-keys
```

Once this is done, you'll need to fix the git remote for the dotfiles repo, as it was cloned using HTTPS.

```sh
git remote set-url origin git@github.com:yukitsune/dotfiles.git
```
