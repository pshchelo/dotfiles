#!/usr/bin/env bash
# TODO: re-implement in Ansible somehow
UV_CMD="uv tool install"

function install_uv {
    if command -v brew > /dev/null 2>&1 ; then
        brew install uv
    elif command -v pip > /dev/null 2>&1 ; then
        PIP_BREAK_SYSTEM_PACKAGES=1 pip install --user uv
    else
        # TODO: support other ways of installing
        echo "No supported installers found (brew or pip)"
        exit 1
    fi
}

function install_main {
    # Python and others development tools
    $UV_CMD bashate
    $UV_CMD bindep
    $UV_CMD crudini
    $UV_CMD flake8
    $UV_CMD git-review --with pysocks
    $UV_CMD ipython
    $UV_CMD mycli
    $UV_CMD pre-commit
    $UV_CMD reno
    $UV_CMD shellcheck-py
    $UV_CMD sshuttle
    $UV_CMD tox
    $UV_CMD uv-virtualenvwrapper
    $UV_CMD yq
    $UV_CMD httpie \
        --with httpie-keystone-auth \
        --with pysocks
    $UV_CMD python-lsp-server \
        --with python-lsp-ruff \
        --with-executables-from ruff \
        --with python-lsp-black \
        --with-executables-from black \
        --with pylsp-mypy \
        --with-executables-from mypy \
        --with pylsp-rope
    # other recoginized optional dependencies possible to inject to pylsp:
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

function install_osc {
    # installs a uv env with python-openstackclient and all plugins
    # for services supported in MOSK
    # the rest are either non-OpenStack services/components,
    # OpenStack but do not have HTTP API (like metering (ceilometer)),
    # or are deprecated in MOSK (like events(panko))
    # base OSC supports Keystone, Nova, Glance, Cinder, Neutron, Swift
    $UV_CMD python-openstackclient \
        --with pysocks \
        --with python-openstackclient \
        --with aodhclient \
        --with gnocchiclient \
        --with osc-placement \
        --with python-barbicanclient \
        --with python-designateclient \
        --with python-heatclient \
        --with python-ironicclient \
        --with python-manilaclient \
        --with python-masakariclient \
        --with python-octaviaclient # this one better from downstream for support of force-delete
    openstack complete > ~/.local/share/bash-completion/completions/openstack
}

function install_demotools {
    # demo recording helpers
    $UV_CMD asciinema
    $UV_CMD demoshell
    $UV_CMD doitlive
}

function install_optional {
    # file manager a-la lf but in Python
    $UV_CMD ranger-fm
    # markdown files viewer
    $UV_CMD frogmouth
    # log viewer
    $UV_CMD toolong
}

function install_dbclients {
    # enhanced DB CLI's - https://www.dbcli.com
    $UV_CMD pgcli
    $UV_CMD litecli
    $UV_CMD iredis
}

function install_guitools {
    # GUI
    # posterize pdf or images to multiple sheets that can be glued together
    $UV_CMD plakativ
    # Steam's proton enhancements
    $UV_CMD protontricks
    # rst/md editor with live HTML preview
    $UV_CMD retext
}

function install_ansible {
    $UV_CMD ansible \
        --with-executables-from ansible-core \
        --with openstacksdk
}

__usage="
Usage: $(basename "$0") [-hvimodbatpg]
Install uv and various sets of packages
Options:
-i install uv
-m install main set of packages I use
-o install python-openstackclient
-a install ansible
-g install gui desktop programs
-d install less used DB clients
-t install demo tools
-p install random assortment of optional packages
-r re-install selected tools
-v verbose mode (set -x)
-h print this message and exit
"

INSTALL_UV=0
INSTALL_MAIN=0
INSTALL_DESKTOP=0
INSTALL_DBCLIENTS=0
INSTALL_OSC=0
INSTALL_OPTIONAL=0
INSTALL_DEMOTOOLS=0
INSTALL_ANSIBLE=0
REINSTALL=0

while getopts ':hvimodbatpgr' arg; do
    case "${arg}" in
        i) INSTALL_UV=1;;
        m) INSTALL_MAIN=1;;
        o) INSTALL_OSC=1;;
        g) INSTALL_DESKTOP=1;;
        d) INSTALL_DBCLIENTS=1;;
        t) INSTALL_DEMOTOOLS=1;;
        p) INSTALL_OPTIONAL=1;;
        a) INSTALL_ANSIBLE=1;;
        r) REINSTALL=1;;
        v) set -x;;
        h) echo "$__usage"; exit 0;;
        *) echo "$__usage"; exit 1;;
    esac
done

[ "$REINSTALL" == "1" ] && UV_CMD+=" --reinstall"
[ "$INSTALL_UV" == "1" ] && install_uv
[ "$INSTALL_MAIN" == "1" ] && install_main
[ "$INSTALL_OSC" == "1" ] && install_osc
[ "$INSTALL_DESKTOP" == "1" ] && install_guitools
[ "$INSTALL_DBCLIENTS" == "1" ] && install_dbclients
[ "$INSTALL_OPTIONAL" == "1" ] && install_optional
[ "$INSTALL_DEMOTOOLS" == "1" ] && install_demotools
[ "$INSTALL_ANSIBLE" == "1" ] && install_ansible
