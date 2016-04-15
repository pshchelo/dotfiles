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
  bootstraps a new vm, makes password-less sudoer and puts ssh keys

devhost
  setups development environment to my liking, using this very repo

desktop
  configures some stuff that only makes sense on the local workstation/desktop

devstack
  prepares (vm) to run DevStack (does not configures it yet)

Examples
========

(As of now) setup a new DevStack VM
(after setting up the networking on the VM and the Ansible inventory
accordingly)::

    ansible-playbook bootstrap.yaml -k --ask-become-pass \
        --skip-tags=desktop \
        -e target=devstack
    ansible devstack -m hostname --args name=devstack
    ansible devstack -a "/sbin/reboot" -b
