# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ] || [ "$(uname)" == "Darwin" ]; then
    if [ "$(uname)" == "Darwin" ]; then
        export CLICOLOR=1
    else
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# On MacOSX, disable archiving extended attributes
if [ "$(uname)" == "Darwin" ]; then
    alias tar="tar --disable-copyfile"
fi

# homebrew on Linux
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
# .. or MacOS
elif [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW_PREFIX="/opt/homebrew"
fi

# set PATH so it includes user's local bin if exists
if [ -d "$HOME/.local/bin" ] && [[ "$HOME/.local/bin" != *"$PATH"* ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set vi/vim as default editor
export EDITOR="vim"
export VISUAL="vim"
export VIEWER="bat"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f "${HOME}/.bash_aliases" ]; then
    . "${HOME}/.bash_aliases"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
    # homebrew
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
    fi
fi

# Setup uv-virtualenvwrapper or virtualenvwrapper, prefer former
UV_VENVVWRAPPER_SCRIPT=$(which uv-virtualenvwrapper.sh)
if [ -n "$UV_VENVVWRAPPER_SCRIPT" ]; then
    source "$UV_VENVVWRAPPER_SCRIPT"
else
    venvwrapper_file_paths="${HOME}/.local/bin/virtualenvwrapper.sh
    /usr/share/virtualenvwrapper/virtualenvwrapper.sh
    /usr/local/bin/virtualenvwrapper/virtualenvwrapper.sh
    /opt/homebrew/bin/virtualenvwrapper.sh"
    for fpath in $venvwrapper_file_paths; do
        if [ -f "$fpath" ]; then
            VENVWRAPPER_SCRIPT="$fpath"
            break
        fi
    done
    if [ -n "$VENVWRAPPER_SCRIPT" ]; then
        if python3 -c 'import virtualenvwrapper' > /dev/null 2>&1; then
            export VIRTUALENVWRAPPER_PYTHON=$(which python3)
        fi
        export WORKON_HOME=$HOME/.virtualenvs
        source "$VENVWRAPPER_SCRIPT"
    fi
fi

DOTFILES="${HOME}/dotfiles"

# solarized scheme for Midnight Commander
export MC_SKIN=${DOTFILES}/colors/mc-solarized.ini

# Disable legacy TTY Software Flow Control
stty -ixon
# Use a vi-style line editing interface.
#set -o vi

function set_fancy_prompt {
    if [ -x "$(command -v starship)" ]; then
        eval "$(starship init bash)"
    elif [ -f "${DOTFILES}/shell/bash_prompt.sh" ]; then
        source "${DOTFILES}/shell/bash_prompt.sh"
    fi
}

# Do not use custom prompt on local ssh connections
self_tty=$(tty)
host_from=$(w | grep "${self_tty:5}" | awk '{print $3}')
case $host_from in
    "localhost"|"::1"|"127.0.0.1")
        : ;;
    *)
        set_fancy_prompt ;;
esac

if [ -x "$(command -v fzf)" ]; then
    eval "$(fzf --bash)"
fi

if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook bash)"
fi

if [ -x "$(command -v thefuck)" ]; then
    eval "$(thefuck --alias)"
fi

export GOPATH="$HOME/src/go"

# CUSTOM FUNCTIONS

# extract kube api IPv4 from active kubeconfig by the cluster name
function k8s-api-ip4 {
    kubectl config view -o jsonpath="{.clusters[?(@.name == \"$1\")].cluster.server}" | awk -F ":" "{print \$2}" | cut -c3-
}
