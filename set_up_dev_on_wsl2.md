
https://superuser.com/questions/1323645/unable-to-change-file-permissions-on-ubuntu-bash-for-windows-10/1392722
If you're referencing files in the Windows file system, they do not, by default, retain Linux permissions. However, there's a way to enable that. Edit or create (using sudo) /etc/wsl.conf and add the following:
[automount]
options = "metadata"
