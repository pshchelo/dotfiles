# enable sudo cred caching
make it similar to Linux/Debian

edit sudoers file with `sudo visudo`, and
change `timestamp_timeout` to non-0 value:
0 - no cred caching
-1 - infinite cred caching (DO NOT DO THIS!!!)
N - cache sudo creds for that many *minutes*

MacOS has it explicitly set to 0 by default for all users.

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
