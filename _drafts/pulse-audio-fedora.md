
Pulseaudio is not starting correctly and then freezing my whole system whenever it wants to beep. Which turns out to be quite often when using tab-complete.

Something about a socket is all ready in use (journalctl command).

Work around is to do this:

sudo rm /tmp/esd-**/socket
sudo pulseaudio -vv

