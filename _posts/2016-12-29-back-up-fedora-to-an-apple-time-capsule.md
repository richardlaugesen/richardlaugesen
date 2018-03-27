---
layout: post
title:  Back up Fedora to an Apple Time Capsule
description: Just use rsync over SSH via an iMac
excerpt: Just use rsync over SSH via an iMac
image:
  thumb: jobs-timecapsule.png
tags:
 - Technology
 - Linux
 - Frustration
 - Fedora
 - Apple
---

{% 
include figure 
image_path="/assets/images/jobs-timecapsule.png"
alt="Steve Jobs burying a time capsule with friends (photo by National Geographic Channel)"
caption="Steve Jobs burying a time capsule with friends (photo by National Geographic Channel)"
%}


At home we use an old Apple Time Capsule to back up our iMac and Air, and I want to do the same for my Fedora 25 workstation. My workstation has about 800GB of stuff in it.

Running rsync over a mounted directory to the Time Capsule turned out to be very unreliable. Connections to the Time Capsule are made using either [AFP](https://en.wikipedia.org/wiki/Apple_Filing_Protocol) or [SMB/CIFS](https://en.wikipedia.org/wiki/Server_Message_Block). And both protocols had their own unique problems which I describe below.

Running rsync over SSH to the iMac turned out to be the best solution. It also gave the largest throughput - around twice as fast as CIFS and ten times faster than AFP.

Stop reading now.

## Now for the details

### Method 1

Backing up the workstation by transferring files directly to the Time Capsule seems like a reasonable approach but it is actually not so great because:

- The Time Capsule disk is not encrypted.
- It does not maintain file metadata as expected.
- Recovering the previous version of a file is not possible. At least not without adding some additional complexity. It’s just a directory from Fedora mirrored to the Time Capsule.
- It turns out that mounting the Time Capsule was pretty flaky.

### Method 2

A better approach is to back up the workstation to the iMac and then let the iMac automagically back itself up to the Time Capsule.

This approach has a few benefits:

- Can use Time Machine on the iMac to roll back any file (from Fedora) to an earlier version.
- File permissions and timestamps are maintained correctly.
- The archive is stored in an encrypted sparse bundle on the Time Capsule.
- Three copies of the data stored on different devices.
- An offsite archive of all 3 computers can be done at once by plugging an external drive into the Time Capsule.

A downside is that we need an iMac in the mix.

---

### Using SSH with method 2 (the winner)

The following will rsync a directory on the Fedora workstation to the iMac.

```
rsync -e ssh -aiv --progress --delete /home/richard/Documents 192.168.0.107:/Users/richard/fedora_archive/
```

And to get things backing up regularly we can add that command to cron (*crontab -e*) to run at 5 minutes past the hour, every hour.

```
05 * * * * rsync -e ssh -aiv --progress --delete /home/richard/Documents 192.168.0.107:/Users/richard/fedora_archive/ >> /var/log/backup-to-imac.log 2>&1
```

The last part of that line will write the ouput from rsync to the */var/log/backup-to-imac.log* file.

To get this running smoothly and avoid entering a password every hour we need to use [SSH keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2).

---

### Using CIFS with method 1 (a failure)

The following will mount the Time Capsule at */media/timecapsule* and set things writable for all users:

```
sudo su

dnf install cifs-util
mkdir /media/timecapsule

mount.cifs //192.168.0.1/Data /media/timecapsule -o pass=***, sec=ntlm, file_mode=0777, dir_mode=0777
```

There is no need to specify a username because we are securing the Time Capsule with the device password rather than user accounts. There is definitely a need to set the security mode to NTLM.

To mount the Time Capsule at startup we need to add an entry to the */etc/fstab* file:

```
//192.168.0.1/Data /media/timecapsule cifs password=***, sec=ntlm, iocharset=utf8, file_mode=0777, dir_mode=0777, _netdev 0 0
```

And to get things backing up we can add a similar rsync command to cron like we did for SSH:

```
05 * * * * rsync -aiv --progress --delete --omit-dir-times --no-group --no-perms /home/richard/Documents /media/timecapsule/fedora_archive/ >> /var/log/backup-to-timecapsule.log 2>&1
```

We need to set the *omit-dir-times*, *no-group*, and *no-perms* options because the Time Capsule doesn't allow such things.

### Connection freezing with CIFS

The rsync job was freezing after what appeared to be a random amount of time. And it happened whether connecting to the Time Capsule over wifi or ethernet.

Lots of the following errors in the journalctl log:

```
CIFS VFS: bogus file nlink value 0
```

And after killing the frozen rsync job, the following error:

```
rsync: [generator] write error: Broken pipe (32)
```

Just using a vanilla copy to transfer files resolved this. There were no freezes.

```
cp -rv ~/Documents /media/timecapsule
```

Of course using copy is not a solution for the backups. We only want to transfer the recent changes since the last backup, not the whole 800GB every time. And to do that we need rsync.

### Failed to set time on dot files with CIFS

Lots of errors during the rsync job about not being able to set times on some dot files:

```
rsync: failed to set times on “/media/timecapsule/fedora_archive/Documents/Archives/code-archives/1/hydro_notebooks/2016–03–09-rl-ereefs-verif-bc/input/Calliope/calibration/catchments/Calliope/HotStart/.UH2_InitState_201512302300.txt.9lZeqY”: Operation not permitted (1)
```

Turns out these are the temporary files that rsync creates while it is transferring. Once the transfer is complete the file is renamed back to its original name. In the example above *.UH2_InitState_201512302300.txt.9lZeqY* would be renamed back to *UH2_InitState_201512302300.txt*.

Perhaps using *--inplace* would help but that comes with it's own set of risks.

---

### Using AFP with method 1 (another failure)

So, perhaps CIFS is no good and AFP will be better.

```
sudo su
dnf install fuse-afp

mkdir /media/timecapsule_afp
chown richard:richard /media/timecapsule_afp

mount_afp -o user=richard 'afp://any:***@192.168.0.1/Data' /media/timecapsule_afp
```

Had to run the *mount_afp* command twice to get it to mount. The first time it reported that the *"Volume Data does not support fixed directories"*. The second time it mounted without error.

Transferring from Fedora to the Time Capsule is the same for AFP as with CIFS and fails in an equally similar way. It froze and I had to find and kill the afpfsd process.

Copying files (instead of rsync) avoided the freezing behaviour but was around five times slower than copying with CIFS.

Additionally after a while the system began reporting this error to the console until the AFP share was unmounted.

```
dsi_recv: Connection reset by peer
Danger, recursive loop
Danger, recursive loop
Danger, recursive loop
Danger, recursive loop
Danger, recursive loop
Danger, recursive loop
Danger, recursive loop
...
```

There is probably a way to make AFP work but I ran out of patience, and that relatively poor throughput wasn’t very motivating.

---

### Using CIFS and AFP with method 2 (another failure)

So how about mounting the iMac with CIFS or AFP and using rsync to transfer the workstation directory across - method 2.

Most of errors seen using CIFS and AFP with the Time Capsule were reproduced when mounting the iMac instead, but seemingly less frequently.

The following line was added to */etc/fstab* to mount an AFP share on the iMac:

```
afpfs#afp://richard:***@192.168.0.107/richard /media/imacca  fuse user=richard, _netdev  0 0
```

It’s a little different to how we mounted the CIFS share because AFP uses [FUSE](https://en.wikipedia.org/wiki/Filesystem_in_Userspace) on Linux.

---

### Conclusion

Would be interesting to investigate why it also failed on the iMac - is my network the problem?

So, what worked for me - back up your Fedora workstation to a Time Capsule by running rsync over SSH to an iMac, then take advantage of the magic of Time Machine.

---

Thanks to [Andrew MacDonald](https://twitter.com/amacd31) for reading drafts of this.
