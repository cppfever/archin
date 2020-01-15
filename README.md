#
Archin - is a scripts for install ArchLinux

Write archin to additional media.
Begin installation of ArchLinux.
Make partitions where ArchLinux will be installed.
Insert media with copy of archin and mount it.
Copy archin directory to the root of installation media.
Change variables in begin of /archin/archin.sh and /archin/newroot.sh 
files for your purposes.
Run archin.sh, it install base system and kernel to target
partition and change root to new filesystem.
Reboot whithout installation media.
Login as root. Run /newroot.sh on the new file system.
Reboot, enable internet commection with wifi-menu or dhcpcd or...
Now you can install X's by your hands)))
