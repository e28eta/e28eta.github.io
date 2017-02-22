---
layout: single
title: Printer Discovery using DNS-SD
date: 2017-02-22 12:55:29
tags: samsung ml-2851, network setup, ddwrt, dnsmasq
published: true
---

Now that the printer doesn't jam, I wanted to make it easy to print to it.

Over the nearly 10 years I've had the printer, I've used it several different ways. Most recently, it was connected via USB to the Mac Mini server, but that was *not* working. It'd print one job and then fail to print the next, because it "couldn't find" the printer. Deleting & recreating the printer in macOS would usually fix it, but having to be available to do that every time my girlfriend needed to print was getting really tiresome (for both of us).

I don't remember why I was using USB instead of the ethernet port, but I suspect it had to do with discoverability: there wasn't any.

Service discovery on macOS happens through mDNS/Bonjour. Typically devices do their own service advertisements, but I was aware that you can configure a DNS server to serve up results. Turns out that's called DNS Service Discovery (DNS-SD), and I only needed [a basic static setup](http://www.dns-sd.org/serverstaticsetup.html).

There are four basic steps in the setup:

1. Who is the DNS-SD nameserver?
2. Declare that there's a printer.
3. Where is the printer located on the network?
4. [What features](https://developer.apple.com/bonjour/printing-specification/bonjourprinting-1.2.pdf) does the printer support?

At this point, I took a detour into BIND before discovering that DNSMasq (included in the DD-WRT firmware running on my router) was **exactly** what I needed.

````
ptr-record=lb._dns-sd._udp.djackson.org,djackson.org
ptr-record=b._dns-sd._udp.djackson.org,djackson.org

ptr-record=_ipp._tcp.djackson.org,ML-2851._ipp._tcp.djackson.org.

srv-host=ML-2851._ipp._tcp.djackson.org.,printer.djackson.org.,631

txt-record=ML-2851._ipp._tcp.djackson.org.,txtvers=1,qtotal=1,rp=printers/ML_2851,ty=Samsung ML-2850 Series PS,adminurl=http://printer.djackson.org./,note=House,priority=0,product=(Samsung ML-2850 Series),"pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/pwg-raster",Duplex=T,Copies=T,printer-type=0x809056
````

This has been working (nearly) perfectly. The printer is *always* discoverable. My only complaint is that now it's impossible to tell when the printer is turned on. Since we rarely use it, we leave the printer turned off most of the time. Strangely, it doesn't give any errors, the print job just disappears. I would have expected it to remain in the print queue until successfully sent.

This has me seriously considering buying a HomeKit-compatible outlet switch for the printer. Maybe if we printed more often than once every couple of weeks.

----

PS: I've been running [handyPrint](http://www.netputing.com/applications/handyprint-v5/) (formerly AirPrint Activator) for years. It's been a great way to print from iOS.

