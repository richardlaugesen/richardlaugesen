---
layout: post
title:  Back up Linux to an Apple Time Capsule
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


At home we use an old Apple Time Capsule to back up our iMac and Air, and I want to do the same for my Fedora workstation. My workstation has about 800GB of stuff in it.

Running rsync over a mounted directory to the Time Capsule turned out to be very unreliable. Connections to the Time Capsule are made using either [AFP](https://en.wikipedia.org/wiki/Apple_Filing_Protocol) or [SMB/CIFS](https://en.wikipedia.org/wiki/Server_Message_Block). And both protocols had their own unique problems.

Running rsync over SSH from Fedora to the iMac turned out to be the best solution. Once the content was on the iMac it was backed up to the Time Capsule just like everything else on the iMac. Interestingly, it also gave the highest throughput - around twice as fast as CIFS and ten times faster than AFP.

Some additional benefits were:

- Backup is encrypted on the Time Capsule.
- Three copies of the data stored on different devices.
- Can roll back any of the Fedora files to an earlier version.
- File permissions and timestamps are maintained correctly.
- Offsite archives of all 3 computers are easy by just plugging an external drive into the Time Capsule.

---

Thanks to [Andrew MacDonald](https://twitter.com/amacd31) for reading drafts of this.
