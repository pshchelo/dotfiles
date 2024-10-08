#!/usr/bin/env bash
SCRIPT_DIR=$(dirname $0)
sudo cp $SCRIPT_DIR/nview $SCRIPT_DIR/nvimdiff /usr/local/bin/
sudo ln -s $(which nvim) /usr/local/bin/nvim
for cmd in vim view vimdiff; do
    sudo update-alternatives --install $(which $cmd) $cmd $(which n$cmd) 100
done
