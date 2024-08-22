#!/usr/bin/env bash
# TODO: re-implement in Ansible using https://docs.ansible.com/ansible/latest/collections/community/general/pipx_module.html
# install pipx
pip install --user pipx

# Python and others development tools
pipx install flake8
pipx install shellcheck-py
pipx install git-review
pipx install tox
pipx install pre-commit
pipx install twine
pipx install bindep
pipx install yq
# python-lsp-server and plugins, expose plugins as tools
pipx install python-lsp-server
pipx inject python-lsp-server --include-deps \
    pylsp-rope \
    pylsp-mypy \
    python-lsp-black \
    python-lsp-ruff
# other recoginized optional dependencies possible to inject:
#McCabe: linter for complexity checking
#pyls-memestra: detecting the use of deprecated APIs.
#
# taken care of by ruff and black:
#Pyflakes: linter to detect various errors
#pycodestyle: linter for style checking
#pydocstyle: linter for docstring style checking (disabled by default)
#autopep8: for code formatting
#YAPF: for code formatting (preferred over autopep8)
#flake8: for error checking (disabled by default)
#pylint: for code linting (disabled by default)
#pyls-isort: code formatting using isort (automatic import sorting).

# installs a pipx env with python-openstackclient and all plugins
# for services supported in MOSK
# the rest are either non-OpenStack services/components,
# OpenStack but do not have HTTP API (like metering (ceilometer)),
# or are deprecated in MOSK (like events(panko))
# NOTE: ironicclient <= 5.7.0 does not support Python 3.12 (not fixed yet), need to install from master
pipx install python-openstackclient # supports Keystone, Nova, Glance, Cinder, Neutron, Swift
pipx inject python-openstackclient \
    aodhclient \
    gnocchiclient \
    osc-placement \
    python-barbicanclient \
    python-designateclient \
    python-heatclient \
    python-ironicclient \
    python-manilaclient \
    python-masakariclient \
    python-octaviaclient # this one better from downstream for support of force-delete
openstack complete > ~/.local/share/bash-completion/completions/openstack

# curl with human face
pipx install httpie
pipx inject httpie httpie-keystone-auth

# demo recording helpers
pipx install asciinema
pipx install demoshell
pipx install doitlive

# kind-a vpn over ssh 
pipx install sshuttle

pipx install ansible --include-deps
pipx inject ansible openstacksdk --include-apps

# OPTIONAL
# file manager a-la lf but in Python
pipx install ranger-fm
# markdown files viewer
pipx install frogmouth
# log viewer
pipx install toolong

# enhanced DB CLI's - https://www.dbcli.com
# pipx install mycli
# pipx install pgcli
# pipx install litecli
# pipx install iredis

# GUI
# posterize pdf or images to multiple sheets that can be glued together
#pipx install plakativ
# Steam's proton enhancements
#pipx install protontricks
# rst/md editor with live HTML preview
#pipx install retext
