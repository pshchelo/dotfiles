#!/usr/bin/env bash
newname=$1
names="ComputerName LocalHostName HostName"
for name in $names; do
    echo -e "current $name is $(scutil --get "$name")"
done

if [ -n "$newname" ]; then
    read -p "Change all host names to $newname. Continue? [y/N]: " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo
        for name in $names; do
            sudo scutil --set "$name" "$newname"
        done
        echo "Changed all host names to $newname"
    fi
fi
