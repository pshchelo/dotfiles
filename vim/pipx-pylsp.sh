#!/usr/bin/env sh

# Use pipx to install python-lsp-server and its plugins I need
pipx install python-lsp-server
pipx inject python-lsp-server \
    python-lsp-black \
    python-lsp-ruff \
    pylsp-mypy \
    pylsp-rope

# other recoginized optional dependencies possible to inject:
#McCabe: linter for complexity checking
#pyls-memestra: detecting the use of deprecated APIs.

# taken care of by ruff and black:
#Pyflakes: linter to detect various errors
#pycodestyle: linter for style checking
#pydocstyle: linter for docstring style checking (disabled by default)
#autopep8: for code formatting
#YAPF: for code formatting (preferred over autopep8)
#flake8: for error checking (disabled by default)
#pylint: for code linting (disabled by default)
#pyls-isort: code formatting using isort (automatic import sorting).
