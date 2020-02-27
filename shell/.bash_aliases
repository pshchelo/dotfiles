#!/usr/bin/env sh
# Define custom personal aliases

# less that opens all and with terminal color control sequences
alias lss='less -fR'

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

# httpie alias for https
alias https='http --default-scheme=https'

# remove stopped containers and dangling images
alias docker-clean="docker ps -a -f status=exited -q | xargs -r docker rm -v && docker images --no-trunc -q -f dangling=true | xargs -r docker rmi"

# login to default dev VMs in the cloud
alias aiossh="ssh -i ~/.ssh/aio_rsa -l ubuntu"

alias kopenstack="kubectl -n openstack exec `kubectl -n openstack get pod -l application=keystone,component=client -ojsonpath='{.items[*].metadata.name}'` -- openstack"
