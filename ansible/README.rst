####################
My Ansible playbooks
####################

Ansible commands should be run from this folder as it defines local config and
roles.

Roles defined so far (WIP):

common
  some common variables

remote
  bootstraps a new remote machine, similar to ``ssh-copy-id``

vm
  bootstraps a new vm, makes password-less sudoer puts private ssh keys,
  updates packages

devhost
  setups development environment to my liking, using this very repo

desktop
  configures some stuff that only makes sense on the local workstation/desktop

devstack
  prepares (vm) to run DevStack (does not configures it yet)

Examples
========

- setup a new VM ready to deploy DevStack
  (after setting up the user and networking on the VM and the Ansible inventory
  accordingly)::

    ansible-playbook devstack.yaml -k --ask-become-pass
    ansible devstack -m hostname --args name=devstack -b
    ansible devstack -a "/sbin/reboot" -b
