Didn't go smoothly again!

This time it caused some hard drive error while running this command:

sudo dnf upgrade

It stopped saying the /var/log/dnf.log is read-only.

Then dumped me into emergency mode after a reboot.

systemctl status systemd-fsck-root

Told me that the root file system failed a check.

So ran:

fsck /dev/mapper/fedora-root

And it found a whole stack of problems which I fixed.

it then came back into Fedora 25 after a reboot.

What a pain!

Bunch of other crap and now booting into a Fedora 25 instance that is half upgraded to 26!

Can't seem to recover from this because of DNF problems.

I think root cause of all this is that the hard drive is buggered, was getting IO errors during the upgrade.
