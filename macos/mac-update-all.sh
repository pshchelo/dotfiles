#!/usr/bin/env bash
brew update
brew upgrade
brew upgrade --casks # --greedy
softwareupdate -i -a
