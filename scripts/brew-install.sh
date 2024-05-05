# see https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install \
    starship \
    jq \
    fzf \
    fd \
    bat \
    lf \
    ripgrep \
    k9s \
    neovim

# for a brew-installed program to be available for sudo, it needs to be
# in `secure_path` paths (https://github.com/orgs/Homebrew/discussions/3575):
# - either add simlinks to standard place like /usr[/local/]/[s]bin 
# - or run `sudo visudo` and append to the secure_path
# :/home/linuxbrew/.linuxbrew/sbin:/home/linuxbrew/.linuxbrew/bin
