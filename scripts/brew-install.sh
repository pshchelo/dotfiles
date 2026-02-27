# #!/usr/bin/env bash
set -e

# see https://brew.sh/
brew_dir="/home/linuxbrew/.linuxbrew"
brew_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
brew_install_script="/tmp/brew-install.sh"

__usage="
Usage: $(basename "$0") [-hcbtkpPv]
Install brew on Linux, and install some software from brew
Options:
    -c  Pre-create brew installation dir manually. Useful when running as user with passwordless sudo.
    -b  Install brew itself
    -p  Show the new needed change in /etc/sudoers to add brew (s)bin paths to secure path
    -P  Create override file in /etc/sudoers.d/ dir to add brew (s)bin paths to secure path
    -t  Install selection of developer CLI tools via brew
    -k  Install selection of Kubernetes-related CLI tools via brew
    -v  verbose (bash -x)
    -h  Print this message and exit
"

function create_brew_prefix {
    me=$(whoami)
    sudo mkdir -p "$brew_dir"
    sudo chown "$me:$me" "$brew_dir"
}

function patch_secure_path {
    local dry_run="$1"
    eval "$(sudo grep secure_path /etc/sudoers | awk '{print $2}')"
    secure_path+=":$brew_dir/sbin:$brew_dir/bin"
    echo "===="
    if [ "$dry_run" == "true" ]; then
        echo "Add the following line to your sudoers file(s):"
        echo -e "Defaults\tsecure_path=\"$secure_path\""
    elif [ "$dry_run" == "false" ]; then
        echo "Creating /etc/sudoers.d/linuxbrew_path file with content:"
        echo -e "Defaults\tsecure_path=\"$secure_path\"" | sudo tee /etc/sudoers.d/linuxbrew_path
    else
        echo "Invalid value for dry_run parameter of 'patch_secure_path', must be 'true' or 'false'"
        exit 1
    fi
    echo "===="
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

function install_brew_devtools {
    $brew_dir/bin/brew install \
        bat \
        fd \
        fzf \
        jq \
        lf \
        mcat \
        micro \
        mosh \
        neovim \
        ripgrep \
        starship \
        tailspin \
        uv \
        yazi

    sudo ln -s $brew_dir/bin/mosh-server /usr/local/bin
}

function install_brew_k8s {
    $brew_dir/bin/brew install \
        helm \
        k9s \
        kubernetes-cli \
        stern
}

CREATE_BREW_PREFIX=0
PATCH_SECURE_PATH=0
SHOW_SECURE_PATH=0
INSTALL_BREW=0
INSTALL_BREW_DEVTOOLS=0
INSTALL_BREW_K8S=0

while getopts ':hcvtkbpP' arg; do
    case "${arg}" in
        c) CREATE_BREW_PREFIX=1 ;;
        b) INSTALL_BREW=1 ;;
        t) INSTALL_BREW_DEVTOOLS=1 ;;
        k) INSTALL_BREW_K8S=1 ;;
        p) SHOW_SECURE_PATH=1 ;;
        P) PATCH_SECURE_PATH=1 ;;
        v) set -x ;;
        h) echo "$__usage"; exit 0;;
        *) echo "$__usage"; exit 1;;
    esac
done

if [[ "$INSTALL_BREW" == "1" ]]; then
    install_brew
fi

if [[ "$SHOW_SECURE_PATH" == "1" ]]; then
    patch_secure_path true
elif [[ "$PATCH_SECURE_PATH" == "1" ]]; then
    patch_secure_path false
fi

if [[ "$INSTALL_BREW_DEVTOOLS" == "1" ]]; then
    install_brew_packages
fi

if [[ "$INSTALL_BREW_K8S" == "1" ]]; then
    install_brew_k8s
fi
