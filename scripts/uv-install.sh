#!/usr/bin/env bash
# TODO: re-implement in Ansible somehow

function install_uv {
    if command -v brew > /dev/null 2>&1 ; then
        brew install uv
    elif command -v pip > /dev/null 2>&1 ; then
        PIP_BREAK_SYSTEM_PACKAGES=1 pip install --user uv
    else
        # TODO: support other ways of installing
        echo "Brew or pip is not detected, other installation methods are unsupported"
        exit 1
    fi
}

function install_main {
    # Python and others development tools
    uv tool install bashate
    uv tool install bindep
    uv tool install crudini
    uv tool install flake8
    uv tool install git-review --with pysocks
    uv tool install ipython
    uv tool install mycli
    uv tool install pre-commit
    uv tool install reno
    uv tool install shellcheck-py
    uv tool install sshuttle
    uv tool install tox
    uv tool install uv-virtualenvwrapper
    uv tool install yq
    uv tool install httpie \
        --with httpie-keystone-auth \
        --with pysocks
    uv tool install python-lsp-server \
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
    uv tool install python-openstackclient \
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
    uv tool install asciinema
    uv tool install demoshell
    uv tool install doitlive
}

function install_optional {
    # file manager a-la lf but in Python
    uv tool install ranger-fm
    # markdown files viewer
    uv tool install frogmouth
    # log viewer
    uv tool install toolong
}

function install_dbclients {
    # enhanced DB CLI's - https://www.dbcli.com
    uv tool install pgcli
    uv tool install litecli
    uv tool install iredis
}

function install_guitools {
    # GUI
    # posterize pdf or images to multiple sheets that can be glued together
    uv tool install plakativ
    # Steam's proton enhancements
    uv tool install protontricks
    # rst/md editor with live HTML preview
    uv tool install retext
}

function install_ansible {
    uv tool install ansible \
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

while getopts ':hvimodbatpg' arg; do
    case "${arg}" in
        i) INSTALL_UV=1;;
        m) INSTALL_MAIN=1;;
        o) INSTALL_OSC=1;;
        g) INSTALL_DESKTOP=1;;
        d) INSTALL_DBCLIENTS=1;;
        t) INSTALL_DEMOTOOLS=1;;
        p) INSTALL_OPTIONAL=1;;
        a) INSTALL_ANSIBLE=1;;
        v) set -x;;
        h) echo "$__usage"; exit 0;;
        *) echo "$__usage"; exit 1;;
    esac
done

[ "$INSTALL_UV" == "1" ] && install_uv
[ "$INSTALL_MAIN" == "1" ] && install_main
[ "$INSTALL_OSC" == "1" ] && install_osc
[ "$INSTALL_DESKTOP" == "1" ] && install_guitools
[ "$INSTALL_DBCLIENTS" == "1" ] && install_dbclients
[ "$INSTALL_OPTIONAL" == "1" ] && install_optional
[ "$INSTALL_DEMOTOOLS" == "1" ] && install_demotools
[ "$INSTALL_ANSIBLE" == "1" ] && install_ansible
