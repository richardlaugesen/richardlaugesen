---
layout: post
title:  Securing archives with encryption
description: Securely archive a directory of files
excerpt: Securely archive a directory of files
image:
  thumb: secure-archives.jpg
tags:
 - Security
 - Linux
 - Backup
 - Technology
 - Archive
---

I want to archive a directory and then encrypt it. And obviously get that directory back again sometime in future.

This will archive, compress, and encrypt:

```
tar -cz some-directory | gpg -c -o archive.tgz.gpg
```

And this will decrypt, decompress, and extract:

```
gpg -d archive.tgz.gpg | tar xz
```

This uses [symmetric encryption](https://en.wikipedia.org/wiki/Symmetric-key_algorithm) with an [AES128](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) cipher. AES128 is sufficient to protect classified information up to the SECRET level. Good enough for me.

{% 
include figure 
class="half"
image_path="/assets/images/secure-archives.jpg"
alt="Another type of secure compression — Image by [Armed in Heels](http://www.armedinheels.com/undertech-undercover-women39s-ultimate-compression-shorts-p-1705.html?CDpath=3)"
caption="Another type of secure compression — Image by [Armed in Heels](http://www.armedinheels.com/undertech-undercover-women39s-ultimate-compression-shorts-p-1705.html?CDpath=3)"
%}
