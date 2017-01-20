---
layout: post
title: Samsung ML-2851ND Paper Jam
date: 2017-01-20 01:45:20
tags: samsung ml-2851
published: false
---
Every time I've watched Office Space, I've understood the printer scene intellectually. However I had never experienced a misbehaving printer. Turns out that it **is** quite frustrating.

I've had a Samsung ML-2851ND for years (apparently 8-ish). I'm still on my first toner cartridge, although I did use it a reasonable amount during college. Since then, it's seen very little use, but eventually I noticed that duplex printing had stopped working: it would **always** jam the printer. Searching the internet for information on paper jams told me that I needed to clean the printer, but it didn't change anything.

Things came to a head when the printer started to jam on every single page printed. I still could not find any dirt on the rollers and no stray paper shards. I was almost ready to chuck the stupid thing in the dumpster and buy a new one, when  I noticed the printer consistently damaged the leading edge of the paper, one to two inches from the left edge. 

There aren't that many moving parts in the paper path, and luckily the culprit was easily accessible. According to this exploded parts diagram, it's `JC61-02399A`, the "GUIDE-CHANGE_DUP":

[![pg 5-10 from Parts Diagram of ML-2851](images/ml-2851_parts_diagram.jpeg)](http://www.arbikas.com/view/locator/ML-2850D.pdf)

![photo of ML-2851 part causing the jams](path/ml-2851_jam_causing_teeth.jpeg)

After fiddling with the part for a little bit, I decided it felt like it was sticking. It turns out the factory installed a small piece of foam on the left edge of this part. The foam was nearly completely compressed, and apparently that was enough to expose the adhesive a little bit. My temporary fix was to simply put a piece of tape over the foam. It's working admirably right now, although when the tape degrades I'll have the same problem again.

![picture with tape added](images/ml-2851_tape.jpeg)

Such a simple fix, for an incredibly aggravating problem.

