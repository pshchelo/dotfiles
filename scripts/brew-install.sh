# #!/usr/bin/env bash
set -e

# see https://brew.sh/
brew_dir="/home/linuxbrew/.linuxbrew"
brew_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
brew_install_script="/tmp/brew-install.sh"

__usage="
Usage: $(basename "$0") [-hc]
Install brew on Linux, and install some software from brew
Options:
  -b  Install brew itself
  -c  Pre-create brew installation dir manually. Useful when running as user with passwordless sudo.
  -i  Install selection of brew packages
  -v  verbose (bash -x)
  -h  Print this message and exit
"

function create_brew_prefix {
    me=$(whoami)
    sudo mkdir -p "$brew_dir"
    sudo chown $me:$me "$brew_dir"
}

function patch_secure_path {
    eval $(sudo grep secure_path /etc/sudoers | awk '{print $2'})
    secure_path+=":$brew_dir/sbin:$brew_dir/bin"
    sudo echo -e "Defaults\tsecure_path=\"$secure_path\"" > /etc/sudoers.d/linuxbrew_path
}

function install_brew {
    wget "${brew_url}" -O "${brew_install_script}"
    echo "Brew installation script has been downloaded as ${brew_install_script}"
    read -p "Do you want to execute it? [y/N]: " -n 1 -r
    if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
        echo "Not performing brew installation"
        exit 0
    fi

    if [[ "$CREATE_BREW_PREFIX" == "1" ]]; then
        create_brew_prefix
    fi

    /bin/bash /tmp/brew-install.sh
    cat << EOF
for a brew-installed program to be available for sudo, it needs to be
in 'secure_path' paths (https://github.com/orgs/Homebrew/discussions/3575):

* either add simlinks to standard place like /usr[/local/]/[s]bin
or
* create an override file in sudoers.d (or edit sudoers with 'visudo')
  and append the following to the secure_path
  :$brew_dir/sbin:$brew_dir/bin

some brew programs may still need to be simlinked to some standard
bin path as they may be launched over remote w/o shell
EOF
}

function install_brew_packages {
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
        starship \
        tailspin

    sudo ln -s $brew_dir/bin/mosh-server /usr/local/bin
}

CREATE_BREW_PREFIX=0
PATCH_SECURE_PATH=0
INSTALL_BREW=0
INSTALL_BREW_PACKAGES=0

while getopts ':hcvib' arg; do
    case "${arg}" in
        c) CREATE_BREW_PREFIX=1 ;;
        b) INSTALL_BREW=1 ;;
        i) INSTALL_BREW_PACKAGES=1 ;;
        v) set -x ;;
        h) echo "$__usage"; exit 0;;
        *) echo "$__usage"; exit 1;;
    esac
done

if [[ "$INSTALL_BREW" == "1" ]]; then
    install_brew
fi

if [[ "$INSTALL_BREW_PACKAGES" == "1" ]]; then
    install_brew_packages
fi
