#!/usr/bin/env bash
sudo -v
fixdir=${1:-$PWD}
fixgrp=${2:-shared}
sudo chgrp -R $fixgrp "${fixdir}"
sudo chmod g+w "${fixdir}"
sudo find "${fixdir}" -type d -exec chmod g+ws '{}' +
sudo find "${fixdir}" -type f -exec chmod g+w '{}' +
