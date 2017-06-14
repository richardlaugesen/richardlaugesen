---
layout: post
title: OpenBSD 6.1 for the desktop
description: Tried OpenBSD 6.1 as a desktop, it was okay
excerpt: Could it be used as an everyday desktop environment?
image:
  thumb: openbsd-banner1.gif
tags:
- Computing
- OpenBSD

---

{%
include figure
image_path="/assets/images/openbsd-banner1.gif"
alt="Gotta love the OpenBSD art! Copyright [Theo de Raadt](http://www.openbsd.org/art1.html)"
caption="Gotta love the OpenBSD art! Copyright [Theo de Raadt](http://www.openbsd.org/art1.html)"
%}

[OpenBSD v6.1](http://www.openbsd.org/61.html) was released a few days ago and I got curious - could it be used as an everyday desktop environment?

The install was much better than last time I tried (v5?). Got it to the point of a running Gnome, Firefox, and Emacs fairly quickly. This surprised me because my FreeBSD days are a long way behind me and I’m now a complete beginner. It was very similar to Linux however and felt sufficiently familiar.

I used it for a few days as my primary desktop environment. The UI seemed a bit laggy but I’m guessing that was because I was running it in a virtual machine. And in general the experience felt a bit crippled and awkward compared to my Fedora desktop. I guess this is just because I don’t understand it and maybe those feelings would vanish with a bit of experience. The man pages and built in documentation are outstanding. And the small amount of code I looked at was very clean.

A common argument in favor of OpenBSD is that it is super secure.

I don't entirely agree with that for a desktop environment?

I’m using the same user-space applications in both OpenBSD and Fedora and any security flaws in those applications are likely to be patched quicker in Fedora. Those applications are surely the majority of my attack surface. Therefore having a more secure operating system to run these applications on becomes less important. Perhaps I'm missing something?

OpenBSD is also missing a few things which I use pretty regularly - Anaconda Python, CUDA, and Mathematica.

And the applications which are available are a couple of versions behind what I have on Fedora. Which adds a potential security risk.

This [article](https://allthatiswrong.wordpress.com/2010/01/20/the-insecurity-of-openbsd/) has a similar argument around security, and also has a pretty nasty comment thread.

If we drop the argument that OpenBSD is more secure, then what are the other benefits one gets from using it?

I really want to love [OpenBSD](http://www.openbsd.org/index.html), maybe I'm just missing something.
