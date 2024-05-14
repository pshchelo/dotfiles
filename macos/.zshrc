export PATH="${PATH}:${HOME}/.local/bin"
# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# ALIASES
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
test -e ~/dotfiles/shell/.bash_aliases && source ~/dotfiles/shell/.bash_aliases

export VIEWER='nvim -R'
export EDITOR='vi'
export VISUAL='nvim'

# brew integration
test -e /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

# direnv integration
eval "$(direnv hook zsh)"

# fzf integration
eval "$(fzf --zsh)"

# starship integration
eval "$(starship init zsh)"

source virtualenvwrapper.sh

# enable autocompletion
autoload -Uz compinit && compinit
# enable bash-style autocompletion
autoload bashcompinit && bashcompinit
