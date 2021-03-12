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

# cat with more eye candy (the bat command was already taken in Debian)
alias bat=batcat

# reset forwarded SSH agent connection inside tmux after detach/relogin/attach
alias fixsshagt='eval $(tmux showenv -s SSH_AUTH_SOCK)'

# alias for running single Python unit tests with testtools
alias ttools='python -m testtools.run'

# do not fail tox on missing interpreters
alias stox='tox --skip-missing-interpreters'

# remove stopped containers and dangling images
alias docker-clean="docker ps -a -f status=exited -q | xargs -r docker rm -v && docker images --no-trunc -q -f dangling=true | xargs -r docker rmi"

# login to default dev VMs in the cloud
alias aiossh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aio_rsa -l ubuntu"

# login to default dev VMs in the cloud via Mosh
alias aiomosh="mosh --ssh 'ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/aio_rsa -l ubuntu'"

# test http(s) connection timings for a URL
alias timecurl="curl -s -w '\nTesting Website Response Time for: %{url_effective}\n\nLookup Time:\t\t%{time_namelookup}\nConnect Time:\t\t%{time_connect}\nPre-transfer Time:\t%{time_pretransfer}\nStart-transfer Time:\t%{time_starttransfer}\n\nTotal Time:\t\t%{time_total}\n' -o /dev/null"

# make authorized calls to OpenStack's APIs (requires openstack client and loaded env vars for it)
alias os-curl='curl -sS -k -H "X-Auth-Token: `openstack token issue -f value -c id`" -H "Content-Type: application/json"'

# calculate free RAM quota in OpenStack project
alias tenantfreeramGB="(openstack limits show --absolute -f value | grep -i totalram | awk '{print \$2}' | sort -rn; echo -1024/p ) | dc"

# search files by fzf and open in vim
alias fvim='vim $(fzf)'

# parse ansible inventory and show the IP of a given host
alias ansible-ip='function _ansible_ip(){ ansible-inventory --host $1 | jq -r .ansible_host; }; _ansible_ip'

# refresh all system software
alias ubuntu-update-all='sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo snap refresh; if [ -f /var/run/reboot-required ]; then cat /var/run/reboot-required && cat /var/run/reboot-required.pkgs; fi'
