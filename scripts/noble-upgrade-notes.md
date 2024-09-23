# Upgrade notes for Ubuntu 24.04 Noble

2 borked upgrades in a row :-(
- PC seems the reason was nvidia, screen went blank, no progress,
  when seems like nothing was doing anything I force-rebooted system,
  still was half-upgraded, had to fiddle a lot with packages and repos to
  get to 'normal' state for 24.04
- Dell XPS notebook is even stranger, upgraded with some errors (not clear
  what exactly), after upgrade there was no sound devices detected,
  and windowing system behaved very flaky (windows being stuck, not able
  to move or maximize, starting up really slow).
  After many attempts to understand what is wrong ended up just backing up
  everything and re-installing 24.04 from scratch,
  everything seems working fine... :-/

In both cases, suspiciously lots of packages were marked as 'will be removed'...

# Learned so far
1. Manually disable screen blanking/lock for the time of the upgrade.
   While upgrade procedure tells you that it is doing this itself,
   just be on a safe side and do it yourself, don't forget to roll back after.
2. If using proprietary Nvidia drivers, switch to opensource neuveu before
   upgrade, and then switch back.
3. Backups (if not everything):
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
   - 'Sound Device chooser' no longer needed really, the default Gnome menu
     now allows to switch outputs just fine.
   - 'No Annoyance' behavior should be possible to replace with
     `gsettings set org.gnome.desktop.wm.preferences focus-new-windows 'smart'`

   
