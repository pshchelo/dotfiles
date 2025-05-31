#!/usr/bin/env bash
# TODO: re-implement in Ansible using https://docs.ansible.com/ansible/latest/collections/community/general/pipx_module.html
# NOTE: these are the python-based tools that are not yet convenient yet
# to install with `uv` https://github.com/astral-sh/uv/issues/6314

function install_pipx {
    # TODO: check if new enough pipx is present in apt repos,
    # and use that if possible
    PIP_BREAK_SYSTEM_PACKAGES=1 pip install --user pipx
    pipx ensurepath
}

function install_lsp {
    # Python and others development tools
    # python-lsp-server and plugins, expose plugins as tools
    pipx install python-lsp-server
    pipx inject python-lsp-server \
        pylsp-rope \
        pylsp-mypy \
        python-lsp-black \
        python-lsp-ruff \
        --include-deps
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
}


function install_ansible {
    pipx install ansible --include-deps
    pipx inject ansible openstacksdk pysocks --include-apps
}

__usage="
Usage: $(basename "$0") [-hvila]
Install pipx and various sets of packages
Options:
-i install pipx
-m install python LSP with extensions
-a install ansible
-v verbose mode (set -x)
-h print this message and exit
"

INSTALL_PIPX=0
INSTALL_LSP=0
INSTALL_ANSIBLE=0

while getopts ':hvila' arg; do
    case "${arg}" in
        i) INSTALL_PIPX=1;;
        l) INSTALL_LSP=1;;
        a) INSTALL_ANSIBLE=1;;
        v) set -x;;
        h) echo "$__usage"; exit 0;;
        *) echo "$__usage"; exit 1;;
    esac
done

if [ "$INSTALL_PIPX" == "1" ]; then
    install_pipx
fi

if [ "$INSTALL_LSP" == "1" ]; then
    install_lsp
fi

if [ "$INSTALL_ANSIBLE" == "1" ]; then
    install_ansible
fi
