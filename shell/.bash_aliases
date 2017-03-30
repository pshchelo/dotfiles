#!/usr/bin/env sh
# Define custom personal aliases

# open files from terminal with GUI default application
alias xopen=xdg-open

# change directory two levels up
alias ...="cd ../.."

# copy command for big files, with progress indication
alias longcp='rsync --progress -ah'

# alias for running single Python unit tests with testtools
alias ttools='python -m testtools.run'

# terminal pastebin
# use as "cat somefile | tb"
alias tb='nc termbin.com 9999'

# openstack CLI as devstack user
alias osdemo='openstack --os-cloud devstack'

# openstack CLI as devstack admin
alias osadmin='openstack --os-cloud devstack-admin'

# less that opens all and with terminal color control sequences
alias lss='less -fR'

# weather forecast from command line
alias wttr='curl wttr.in'

# do not fail tox on missing interpreters
alias stox='tox --skip-missing-interpreters'

# re-create virtualenv via virtualenvwrapper
# workaround for bug https://bitbucket.org/virtualenvwrapper/virtualenvwrapper/issues/291
alias wipeenv='v=$(basename ${VIRTUAL_ENV});deactivate;rmvirtualenv $v;mkvirtualenv $v'
