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
alias osadmin='openstack --os-cloud devstack-admin --os-baremetal-api-version latest'

# openstack CLI for internal devcloud
alias osdev='openstack --os-cloud devcloud'

# less that opens all and with terminal color control sequences
alias lss='less -fR'

# weather forecast from command line
alias wttr='curl wttr.in'

# do not fail tox on missing interpreters
alias stox='tox --skip-missing-interpreters'

# get value for given Heat stack output from named cloud (3 args - cloud, stack name, output name)
alias stackoutput='openstack stack output show -f value -c output_value --os-cloud'
