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
