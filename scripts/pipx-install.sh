#!/usr/bin/env bash
# TODO: re-implement in Ansible using https://docs.ansible.com/ansible/latest/collections/community/general/pipx_module.html

function install_pipx {
    # TODO: check if new enough pipx is present in apt repos,
    # and use that if possible
    PIP_BREAK_SYSTEM_PACKAGES=1 pip install --user pipx
    pipx ensurepath
}

function install_main {
    # Python and others development tools
    pipx install \
        bindep \
        flake8 \
        git-review \
        pre-commit \
        shellcheck-py \
        sshuttle \
        tox \
        twine \
        yq
    # curl with human face
    pipx install httpie
    pipx inject httpie httpie-keystone-auth
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

function install_osc {
    # installs a pipx env with python-openstackclient and all plugins
    # for services supported in MOSK
    # the rest are either non-OpenStack services/components,
    # OpenStack but do not have HTTP API (like metering (ceilometer)),
    # or are deprecated in MOSK (like events(panko))
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
}

function install_demotools {
    # demo recording helpers
    pipx install asciinema
    pipx install demoshell
    pipx install doitlive
}

function install_ansible {
    pipx install ansible --include-deps
    pipx inject ansible openstacksdk --include-apps
}

function install_optional {
    # file manager a-la lf but in Python
    pipx install ranger-fm
    # markdown files viewer
    pipx install frogmouth
    # log viewer
    pipx install toolong
}

function install_dbclients {
    # enhanced DB CLI's - https://www.dbcli.com
    pipx instal \
        pgcli \
        litecli \
        iredis \
        mycli
}

function install_guitools {
    # GUI
    # posterize pdf or images to multiple sheets that can be glued together
    pipx install plakativ
    # Steam's proton enhancements
    pipx install protontricks
    # rst/md editor with live HTML preview
    pipx install retext
}

__usage="
Usage: $(basename "$0") [-hvimodbatpg]
Install pipx and various sets of packages
Options:
-i install pipx
-m install main set of packages, includes LSP and other code tools
-o install python-openstackclient
-g install gui desktop programs
-d install DB clients
-a install ansible
-t install demo tools
-p install random assortment of optional packages
-v verbose mode (set -x)
-h print this message and exit
"

INSTALL_PIPX=0
INSTALL_MAIN=0
INSTALL_DESKTOP=0
INSTALL_DBCLIENTS=0
INSTALL_OSC=0
INSTALL_ANSIBLE=0
INSTALL_OPTIONAL=0
INSTALL_DEMOTOOLS=0

while getopts ':hvimodbatpg' arg; do
    case "${arg}" in
        i) INSTALL_PIPX=1;;
        m) INSTALL_MAIN=1;;
        o) INSTALL_OSC=1;;
        g) INSTALL_DESKTOP=1;;
        d) INSTALL_DBCLIENTS=1;;
        a) INSTALL_ANSIBLE=1;;
        t) INSTALL_DEMOTOOLS=1;;
        p) INSTALL_OPTIONAL=1;;
        v) set -x;;
        h) echo "$__usage"; exit 0;;
        *) echo "$__usage"; exit 1;;
    esac
done

if [ "$INSTALL_PIPX" == "1" ]; then
    install_pipx
fi

if [ "$INSTALL_MAIN" == "1" ]; then
    install_main
fi

if [ "$INSTALL_OSC" == "1" ]; then
    install_osc
fi

if [ "$INSTALL_DESKTOP" == "1" ]; then
    install_guitools
fi

if [ "$INSTALL_DBCLIENTS" == "1" ]; then
    install_dbclients
fi

if [ "$INSTALL_ANSIBLE" == "1" ]; then
    install_ansible
fi

if [ "$INSTALL_OPTIONAL" == "1" ]; then
    install_optional
fi

if [ "$INSTALL_DEMOTOOLS" == "1" ]; then
    install_demotools
fi
