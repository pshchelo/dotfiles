# Upgrade notes for Ubuntu 24.04 Noble

1. Manually disable screen blanking/lock for the time of the upgrade.
   While upgrade procedure tells you that it is doing this itself,
   just be on a safe side and do it yourself, don't forget to roll back after.
2. If using proprietary Nvidia drivers, switch to open source neuveu drivers
   before upgrade, and then switch back to proprietary after upgrade.
3. Backups (at least, presuming `/home` is on a separate partition so chances
   of it getting broken are minimal):
   - `/etc` folder, upgrade asks several times to overwrite
     some custom changes (grub etc).
     My general approach is to let it install 'the maintainer version'
     to be up to date with new config options and defaults,
     and re-introduce my custom changes afterwards.
     During upgrades, keep notes on what files have to be re-examined manually.
   - `apt list --installed | grep -v ',automatic'` - installed manually
   - `snap list`
   - `flatpak list`
   - `docker image list` (less important)
   - list of `/opt` - some software might be there and not show up in `apt list`
5. Disable all personal Gnome extensions before upgrade, some/many will not
   work with Gnome 46.
   - `Sound Device chooser` no longer needed really, the default Gnome menu
     now allows to switch outputs just fine.
   - `No Annoyance` behavior should be possible to replace with
     `window-is-ready-notification-remover`
     and ensuring the following Gsetting is set to `smart` (seems like it should
     be default, but double check, use `dconf` UI or `gsettings` CLI for that)
     `org.gnome.desktop.wm.preferences.focus-new-windows`
