---
layout: post
title:  Destroy ZFS snapshots matching a keyword
description: Destroy ZFS snapshots matching a keyword
excerpt: Destroy ZFS snapshots matching a keyword
tags:
 - Security
 - Linux
 - Backup
 - Technology
 - Archive
 - zfs
---

I've got too many snapshots but I don't want to delete them all. No one seems to have written down the required magic.

The following worked for me:

```
zfs list -r -t snapshot -o name big/stuff | grep aaarrghh | xargs -n1 zfs destroy 
```

It will delete all snapshots with the word 'aaarrghh' in its name from the file-system 'big/stuff'.
