# #!/usr/bin/env bash

# For linux machine with passwordless sudo,
# manuallly pre-create the brew install prefix dir,
# otherwise the install script will keep asking for the password,
# for default prefix this looks like:

#brew_dir="/home/linuxbrew/.linuxbrew"
#me=$(whoami)
#sudo mkdir -p "$brew_dir" && sudo chown $me:$me "$brew_dir"

# see https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


brew install \
    bat \
    fd \
    fzf \
    helm \
    jq \
    k9s \
    kubectl \
    lf \
    lnav \
    mosh \
    neovim \
    ripgrep \
    starship

# for a brew-installed program to be available for sudo, it needs to be
# in `secure_path` paths (https://github.com/orgs/Homebrew/discussions/3575):
# - either add simlinks to standard place like /usr[/local/]/[s]bin
# - or run `sudo visudo` and append to the secure_path
# :/home/linuxbrew/.linuxbrew/sbin:/home/linuxbrew/.linuxbrew/bin
