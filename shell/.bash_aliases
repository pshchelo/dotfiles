#!/usr/bin/env sh
# Define custom personal aliases

# less that opens all and with terminal color control sequences
alias lss='less -fR'

# show clean ini file
alias inishow='grep -Ev "^(#|$)"'

# copy command for big files, with progress indication
alias longcp='rsync --progress -ah --sparse'

# terminal pastebin, use as "cat somefile | tb"
alias tb='nc termbin.com 9999'

# open files from terminal with GUI default application
alias xopen=xdg-open

# reset forwarded SSH agent connection inside tmux after detach/relogin/attach
alias fixsshagt='eval $(tmux showenv -s SSH_AUTH_SOCK)'

# alias for running single Python unit tests with testtools
alias ttools='python -m testtools.run'

# do not fail tox on missing interpreters
alias stox='tox --skip-missing-interpreters'

# login to default dev VMs in the cloud via ssh
alias aiossh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aio_rsa -o LogLevel=ERROR"
alias aioscp="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aio_rsa -o LogLevel=ERROR"

# login to default dev VMs in the cloud via Mosh
alias aiomosh="mosh --ssh 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aio_rsa -o LogLevel=ERROR -l ubuntu'"

# login to default dev VMs in the cloud via sshuttle
alias aiosshuttle="sshuttle -e 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aio_rsa -o LogLevel=ERROR -l ubuntu'"

# test http(s) connection timings for a URL
alias timecurl="curl -s -w '\nTesting Website Response Time for: %{url_effective}\n\nLookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null"

# make authorized calls to OpenStack's APIs (requires openstack client and loaded env vars for it)
alias os-curl='curl -sS -k -H "X-Auth-Token: `openstack token issue -f value -c id`" -H "Content-Type: application/json"'

# aliases for httpie with OpenStack
alias os-https='https -A keystone --verify=false'
alias os-http='http -A keystone --verify=false'

# search files by fzf and open in vim
alias fvim='vim $(fzf)'

alias lxc-as-me="lxc exec --user 1000 --group 1000 --env HOME=\$HOME"

alias tmax='tmux new -As'

alias kopenstack="kubectl -n openstack exec -ti deploy/keystone-client -c keystone-client -- openstack"

alias gitroot='cd $(git rev-parse --show-toplevel)'
alias groot='cd $(git rev-parse --show-toplevel)'
