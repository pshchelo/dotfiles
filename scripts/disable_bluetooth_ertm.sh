#!/usr/bin/env sh

# ERTM may mess with Xbox One (S) controllers,
# making them constantly reconnect.
# If possible, try to update conroller firmware first.
# Disabling may make some adverse impact
# on some Bluetooth audio devices though.

# disable immediately, does not persist after reboot
sudo sh -c 'echo 1 > /sys/module/bluetooth/parameters/disable_ertm'

# disable permanently
override_file="/etc/modprobe.d/disable_bluetooth_ertm.conf"
if [ ! -f $override_file ]; then
    sudo sh -c "echo options bluetooth disable_ertm=1 > $override_file"
else
    echo "file already exists! $override_file"
    exit 1
fi
