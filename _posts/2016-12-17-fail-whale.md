---
layout: post
title:  Fail whale
description: Solve the Gnome fail whale after upgrading Fedora
excerpt: Solve the Gnome fail whale after upgrading Fedora
image:
  thumb: gnome-fail-whale.png
tags:
 - Technology
 - Frustration
---

{% 
include figure 
image_path="/assets/images/gnome-fail-whale.png"
alt="The terrifying Gnome fail whale"
caption="The terrifying Gnome fail whale"
%}


Upgrading to Fedora 25 was as easy as clicking a button in Fedora 24 then waiting.

But after the reboot it didn't come back up as expected. Instead it displayed the image above. I believe this is known as the Gnome Fail Whale.

And this is what fixed it for me:

0. See the Gnome Fail Whale
1. Press Ctrl-Alt-F2 to drop into single user mode
2. Sign in as my normal user
3. Edit this file /usr/share/gnome-session/sessions/gnome.session as sudo
4. Remove gnome-settings-daemon; from the last line
5. Reboot

Not yet sure what the consequences of this are besides frustration.
