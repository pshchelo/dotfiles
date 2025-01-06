# manage host name
see `mac-hostname.sh` script next to this file for automated way
## computer name
```
scutil [--get|--set] ComputerName
```
Can be changed also via Settings -> General -> About -> Name

## local host name
```
scutil [--get|--set] LocalHostName
```
Can be changed via Settings -> General -> Sharing -> Local hostname

## hostname
```
scutil [--get|--set] HostName
```
This is what is reported by `hostname` command in terminal.

# enable sudo cred caching
make it similar to Linux/Debian

use `visudo` to create a drop in override in `/etc/sudoers.d/` folder like
```
sudo visudo -f /etc/sudoers.d/timestamp
```
with the following content
```
Defaults	timestamp_timeout=N
```
Where `N` is desired INT value for *minutes* to cache the sudo creds for, with
`0` meaning no cred caching (the default in MacOSX), and 
`-1` meaning infinite cred caching (**DO NOT DO THIS!!!**)

Can also change it for single user like
```
Defaults:<username> timestamp_timeout=5
```

# install and use new bash
zsh is different enough for my scripts and configs to not work as I want them,
and I also very frequently work on Linux in bash too.
At the same time, but default bash on MacOS is really old, sudo
`brew install bash` it goes.

Change default shell for self with `chsh -s /opt/homebrew/bin/bash`,
or better not to meddle with defaults and just configure
Terminal.app or iTerm2 to use that shell in default profile.

## bash completion
`brew install bash-completion@2` for brew-installed bash
Some commands may need manual massaging..
### git bash completion
`git` is a system app in MacOS (can't find it in brew even), so it keeps
its completion for default system bash (the old one), and brew-installed one
does not know about them.
So just link the system git completions file to local dir where (brew-installed)
bash completion will find it:
```
mkdir -p ~/.local/share/bash-completion/completions
ln -s /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ~/.local/share/bash-completion/completions/git
```
### ag bash completion is broken
https://github.com/termux/termux-packages/issues/19352#issuecomment-1964379475
`ag` was not updated to bash-completion 2.12 and uses private functions that
were renamed, thus completion is broken with latest bash-completion version.

*fix* Find `ag` completion file
`$(brew --prefix)/etc/bash_completion.d/ag.bashcomp.sh`
and replace the `_split_longopt` call with `_comp__split_longopt`.

# routing table
## show routing table
```
netstat -rn
```
## manipulate routing table
```
route <add|delete> <cidr> -interface <iface>
```
see `man route` for more info

# .DS_Store files

disable on network volumes (may break samba/onecloud etc)
```
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```
disable on removable USB media
```
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
```

# python-pcre
```
brew install pcre
brew list pcre | grep pcre.h
cpp -v # find include locations
# than link pcre.h to some of those locations, e.g.
sudo ln -s /opt/homebrew/Cellar/pcre/8.45/include/pcre.h /Library/Developer/CommandLineTools/usr/include/pcre.h
```

# Karabiner config files
custom complex rule definitions are to be placed in
`~/.config/karabiner/assets/complex_modifications/` folder.

# Disable creating junk metadata files in archives
Use undocumented `COPYFILE_DISABLE` env var, e.g.
```
COPYFILE_DISABLE=1 tar cf <archivename> ...
```
