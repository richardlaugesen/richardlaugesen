---
layout: post
title: Browse files on Mac from Linux
description: Mount a directory on Apple iMac and browse files on Fedora Linux 
excerpt: All wasps were gone by the second week of May, and the nests became a great preschool show-and-tell activity.
tags:
- Linux
- Apple

---

I want to browse files on my Apple iMac from my Fedora laptop.

Why? So I can find a photo of a baby carrier my wife wants, but do it while sitting on the sofa watching the Tour De France in the lounge. 

Tried connecting with Samba from the Gnome file manager but it didn't work. This did though:

```
sudo dnf install fuse-sshfs
sshfs richard@192.168.0.108:/users/richard/ mac
```

Now if only there was a search box I can type "green baby carrier with colourful patterns from around 2013" into.
