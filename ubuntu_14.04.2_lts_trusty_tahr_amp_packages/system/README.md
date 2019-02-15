motd.tail -> /etc/motd.tail
rc.local  -> /etc/rc.local

sudoers -> /etc/sudoers

Sudo does not load login shell env to execute the command and we need
to disable secure_path setting and enable PATH keeping for processes
spawned by sudo.