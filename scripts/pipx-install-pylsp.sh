#!/usr/bin/env bash
pipx install python-lsp-server
pipx inject python-lsp-server --include-deps \
    pylsp-rope \
    pylsp-mypy \
    python-lsp-black \
    python-lsp-ruff
