#!/usr/bin/env bash
sudo -v
fixdir=${1:-$PWD}
fixgrp=${2:-shared}
sudo chgrp -R $fixgrp "${fixdir}"
sudo chmod -R g+rw,o-rwx "${fixdir}"
sudo find "${fixdir}" -type d -exec chmod g+s '{}' +
sudo find "${fixdir}" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.arw' \) -exec chmod -x '{}' +
