
How to mount an encrypted LVM volume on Fedora 25.

Story about why I want to do this. Moving from Ubuntu to Fedora on a VirtualBox

What devices are connected to the machine?

```
lsblk
``` 
(-f is good too)

**show output**

Let's try mounting sdb5

```
mount /dev/sdb5 /media/euler
```

**show output**

Wont work because it is an encrpyted partition

Let's create a mapping to the decrypted contents

First find the UUID

```
cryptsetup luksUUID /dev/sdb5
```

Then map this to the name euler, it will ask for the encryption key

```
cryptsetup luksOpen /dev/sdb5 euler
```

Get some info on it

```
dmsetup info euler
```

And now see what our layout looks like

```
lsblk

NAME                                        MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sdb                                           8:16   0   40G  0 disk  
├─sdb2                                        8:18   0    1K  0 part  
├─sdb5                                        8:21   0 39.5G  0 part  
│ └─euler                                   253:3    0 39.5G  0 crypt 
│   ├─ubuntu--vg-root                       253:4    0 33.5G  0 lvm   
│   └─ubuntu--vg-swap_1                     253:5    0    6G  0 lvm   
└─sdb1                                        8:17   0  487M  0 part  
sr0                                          11:0    1 1024M  0 rom   
sdc                                           8:32   0   10G  0 disk  
sda                                           8:0    0   50G  0 disk  
├─sda2                                        8:2    0   49G  0 part  
│ └─luks-2cc68917-f79e-4d8e-87dc-e140f62cfa55
│   253:0    0   49G  0 crypt 
│   ├─fedora-root                           253:1    0   44G  0 lvm   /
│   └─fedora-swap                           253:2    0    5G  0 lvm   [SWAP]
└─sda1                                        8:1    0    1G  0 part  /boot
```

We cannot mount the euler mapping directly because as we can see it actually contains LVM volumes, we need to mount those.

```
mount /dev/mapper/euler /media/euler
mount: unknown filesystem type 'LVM2_member'
```

So, what LVM volumes do we have?

```
vgscan
Reading volume groups from cache.
Found volume group "ubuntu-vg" using metadata type lvm2
Found volume group "fedora" using metadata type lvm2
```

First you need to activate the volume

```
vgchange -ay ubuntu-vg
  2 logical volume(s) in volume group "ubuntu-vg" now active
[root@localhost media]# lvs
  LV     VG        Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root   fedora    -wi-ao---- 44.00g                                                    
  swap   fedora    -wi-ao----  5.00g                                                    
  root   ubuntu-vg -wi-a----- 33.49g                                                    
  swap_1 ubuntu-vg -wi-a-----  6.00g                                                    
```

And now we can finally mount the volume in a standard way

```
mount /dev/ubuntu-vg/root /media/euler -o ro,user
```

And it worked

```
ls /media/euler
bin    dev   initrd.img      lib64       mnt   root  snap  tmp  vmlinuz
boot   etc   initrd.img.old  lost+found  opt   run   srv   usr  vmlinuz.old
cdrom  home  lib             media       proc  sbin  sys   var
```

Unfortunatly it didn't actually solve my problem because the home directory I want is further encrypted with encryptfs

```
dnf install ecryptfs-utils

cat /media/euler/home/richard/README.txt
THIS DIRECTORY HAS BEEN UNMOUNTED TO PROTECT YOUR DATA.

From the graphical desktop, click on:
 "Access Your Private Data"

or

From the command line, run:
 ecryptfs-mount-private
```

So lets try mounting it as instructed

```
ecrypt-mount-private
ERROR: Encrypted private directory is not setup properly
```

These pages were useful: 
https://fedoraproject.org/wiki/Disk_Encryption_User_Guide
https://superuser.com/questions/116617/how-to-mount-an-lvm-volume
