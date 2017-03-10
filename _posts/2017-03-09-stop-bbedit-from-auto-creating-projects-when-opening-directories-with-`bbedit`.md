---
layout: single
title: Stop BBEdit From Auto-Creating Projects When Opening Directories With `bbedit`
date: 2017-03-09 17:43:34
tags: bbedit
published: true
---

The [BBEdit 9.3 release notes ](http://www.barebones.com/support/bbedit/arch_bbedit93.html) say:

> BBEdit offers a new behavior: when you ask it to open a folder, rather than creating a disk browser (which allows only one document open at a time), you can ask it to create a temporary project. [...]
>
> There is no GUI for changing this behavior. If you want the old behavior back, use this command line:
>
```
defaults write com.barebones.bbedit Misc:MakeTempProjectForFolderOpen -bool NO
```


I've briefly tried using Projects a couple times, but they've never clicked with me. So I always set this.

However, when I set up my new iMac a year ago it didn't work, and I didn't bother to figure out why. I thought maybe the hidden preference had finally been dropped (currently using v11.6) and I'd have to learn to live with Projects. I don't know why I didn't check my mid-2011 Mac Mini. Fast forward to today, and I notice that `bbedit .` on the Mini **does not** open a project. A quick look through the `defaults read` output, and it turns out `Misc:` was dropped at some point.

Even knowing this now, I still can't find updated instructions through Google. Hopefully I'll be able to find *this* blog post the next time I need to figure it out.

```
defaults write com.barebones.bbedit MakeTempProjectForFolderOpen -bool NO
```
