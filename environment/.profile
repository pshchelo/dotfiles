# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# LANG=en_US.UTF-8
# LANGUAGE=en_US.UTF-8
# LC_NUMERIC=en_US.UTF-8
# LC_MONETARY=en_US.UTF-8
# LC_NAME=en_US.UTF-8
# LC_ADDRESS=en_US.UTF-8
# LC_TELEPHONE=en_US.UTF-8
# LC_IDENTIFICATION=en_US.UTF-8
# Britain locale settings for sane European defaults
# LC_MEASUREMENT=en_GB.UTF-8
# LC_TIME=en_GB.UTF-8
# LC_PAPER=en_GB.UTF-8
# PAPERSIZE=a4

if [ "$(uname)" = "Darwin" ]; then
    export LANG=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
fi

# set vi/vim as default editor
export EDITOR="vim"
export VISUAL="vim"
export VIEWER="bat"

export GOPATH="$HOME/src/go"

# set PATH so it includes user's local bin if exists
#if [ -d "$HOME/.local/bin" ] && ! [ $(echo "$PATH" | grep "$HOME/.local/bin") ]; then
if [ -d "$HOME/.local/bin" ]; then
    case "$PATH" in
        *"$HOME/.local/bin"*)
            ;;
        *)
            PATH="$HOME/.local/bin:$PATH"
            ;;
    esac
fi
if [ -d "$HOME/src/go/bin" ]; then
    case "$PATH" in
        *"$HOME/src/go/bin"*)
            ;;
        *)
            PATH="$HOME/src/go/bin:$PATH"
            ;;
    esac
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
