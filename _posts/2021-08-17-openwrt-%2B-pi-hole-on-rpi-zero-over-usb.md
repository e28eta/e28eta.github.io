---
layout: single
title: OpenWrt + Pi-Hole on Rpi Zero over USB
date: 2021-08-17 15:55:33
tags: [network setup,dnsmasq,openwrt,raspberry pi]
published: true
---

Several years ago, I decided to try out network-level ad blocking at home. I had an extra Raspberry Pi Zero W, and a coworker mentioned they were happy with [Pi-hole](https://pi-hole.net). I spent several days messing with our network setup, and finally got something I was happy with. At the time, I didn’t take great (any?) notes, and while in theory I knew what I’d done and how to reproduce it, now that I’ve re-created the setup for new router hardware I’m going to add it to this blog. This will be heavy on rationale, and light on step-by-step since I find that’s most helpful for me.

### UniFi AP
I jumped on the UniFi bandwagon in 2017, after we started getting 802.11ac devices. I like that it’s independently upgradable, and that I can run a single wire to a central location to achieve decent Wifi coverage at our house. The fact that it took me two years before I chose that spot and ran that wire in our new home is a different conversation 😭. I expect to get many years out of it, and hope that I’ll be able to just drop in a replacement when the time comes.

### Router
Until a couple days ago, I’ve been using the same router since 2009 ([D-link DIR-825](https://openwrt.org/toh/d-link/dir-825)) [1]. It met our needs: gigabit ethernet & adequate routing speed. However, when COVID hit and we started video conferencing from home more often, I was entirely unsatisfied with Xfinity’s 5 Mb upload speed. So we upgraded to the 600/15 plan, and subsequently found out the router couldn’t support routing packets at the speed required to saturate our download. Honestly though, it wasn’t a huge issue for me since we were satisfied and I’d mostly upgraded for the 3x faster (but still **miniscule** 🤬) upload speed.

For a replacement, I wanted gigabit ethernet, a USB port (for the pi-hole), and solid [OpenWrt](https://openwrt.org) support. Reviews of consumer routers focus quite a bit on wifi capabilities, which doesn’t matter for us because of the UniFi, and that made it harder to pick something. I found [GL.iNet](https://www.gl-inet.com)’s product line while looking for routers that run OpenWrt natively, and picked one that looked reasonable: the [Brume](https://www.gl-inet.com/products/gl-mv1000/). It may end up being the wrong choice (I haven’t yet verified if it saturates our download), but if I do end up replacing it I think I still like the form-factor as a travel router.

I shied away from the UniFi / Mikrotik (& others?) class of products because it seemed like they (rightly) charge a premium to support their custom software development, and I _think_ my needs are met with the open source & free alternatives. Additionally, I _know_ that my desired setup is possible with OpenWrt.

### Pi-Hole: Ad Blocking, DNS & DHCP
It is still true that `dnsmasq` is one of my [favorite features]({% post_url 2017-02-22-dnsmasq-is-my-favorite-router-feature %}) of our local network (ad blocking is probably #1 these days), but it’s no longer running on the router. I knew that network-level ad blocking worked by overriding DNS entries, and I was pleased to see that the Pi-hole software project is built on top of `dnsmasq`, because it meant I wouldn’t have to give up local host name resolution.

However, a conundrum: in order for the DNS server to serve results based on local host names, it has to know the mapping between hostnames and local IP addresses. The easiest way to do that is for the Pi-hole to be the local DHCP server. And that means the local network is "broken" if the server is down or unreachable - which is an argument for running that software on something hardwired to the network, instead of connected via wifi. But the Pi Zero doesn't have a built-in ethernet port.

Here’s where USB enters the picture. The Pi Zero has the ability to plug into a host via USB, and present itself as a networked device. Some search terms are "Ethernet Gadget" or "USB Gadget", and I'm using the `g_ether` module. This is a very well documented configuration, and (currently) requires just a few changes to `/boot/config.txt`, `/boot/commandline.txt`, and then configuration of the resulting `usb0` interface with appropriate network settings (in my case, a static IP on the local subnet). The Pi-hole software wants you to set up that interface through its installer (or subsequently via [`pihole reconfigure`](https://docs.pi-hole.net/core/pihole-command/#reconfigure)), which is nice because it updates the DHCP settings at the same time.

I'm pretty happy with the elegance of this configuration. The router has a USB port, and as long as the router's powered up so is the Pi Zero. I've found the software to be incredibly stable. IDK how USB 2.0 compares to wifi with respect to speed / latency / throughput. I haven't cared to try to benchmark it, but as far as I can tell this hasn't added any significant latency to our internet usage.

If I remember correctly, I struggled a bunch the first time around because I was trying to set up both the Pi and the router with ethernet over USB at the same time. This time around I put the Zero on our wifi via `/boot/wpa_supplicant.conf`, ensuring I could access it regardless of the success/failure of the ethernet gadget setup and making it easy to download/install software before finishing the `usb0` interface setup. Then I used my Mac (which "just works" when the Zero is plugged in via USB: it shows up as an Ethernet/RNDIS device in the Network system preference pane) to double check that the interface came up as expected.

One **important** thing to remember is that only one of the Pi Zero’s USB ports works for this: the one closer to the center of the board. I’ve blocked the other port with some tape to prevent making that mistake again.

### USB on OpenWrt
I remembered having a lot of trouble with this the first time. It’s similar to setting up smartphone tethering (ie: I have a USB device that I want to treat as a network interface), and I found lots of conflicting / overlapping instructions. It’s not the same as tethering, because you want the USB device to be part of the LAN instead of serving as the WAN interface, but that actually makes it easier. This time it was super easy, and I was able to do it all through the UI 😱.

1. The first step is installing the kernel module(s). `kmod-usb-net` might be [sufficient](https://openwrt.org/docs/guide-user/network/wan/smartphone.usb.reverse.tethering); I went with `kmod-usb-net-rndis` (which depends on the former) because I believed the extra module wouldn’t hurt and might help. The Software tab of the GUI made it easy, or use `opkg` on the command line. I chose to reboot, which may not have been necessary.
2. Plug in the Pi. I churned for a while trying to get the `usb0` network interface to show up, until I realized it’d happen automatically once there was something plugged in 🤦‍♂️.
3. Add the `usb0` interface to the (already existing) `br-lan` "Bridge Device". I dimly remember having to (or thinking I had to?) create the bridge myself the first time around, and spending lots of time reading the `ifconfig` man page. I don’t know if that’s a software change, a hardware-specific difference (since this router shows each internal ethernet port as a different interface), or an extra step I didn’t actually have to do last time. As the step I was dreading the most, I was so grateful when it was accomplished with a handful of clicks.

![OpenWrt settings showing br-lan with usb0]({{ site.url }}/images/openwrt-br-lan-with-usb0.jpeg)

### Software config settings
There’s not much more to it, but here are some settings that go along with this setup.

#### OpenWrt
* Disable the built-in DHCP server!
* Static network setup matching the Pi-hole (I have the router as `.1` and the Pi as `.2`), by this point it's probably already done, but I'm covering my bases.
* Pick good passwords, set up SSH keys, prevent WAN SSH access
* Disable Wifi in favor of UniFi AP's, if needed. My clean install of the latest OpenWrt (21.02.0-rc4) doesn't have *any* WiFi config settings available in the LuCI interface, which is great for my use case but seems like an **odd** default to me. ("Devices that have Ethernet ports have Wi-Fi turned off by default" per [Enabling WiFi](https://openwrt.org/docs/guide-quick-start/basic_wifi))

#### Pi-hole
* Add local hostname & IP for router to `/etc/pihole/custom.list` (or through GUI at `Local DNS -> DNS Records`)
* Configure DHCP with non-overlapping ranges for static and dynamic leases, and set up any static leases desired.
* I’m using a "real" domain name for internal devices, and had to **disable** `DNS -> Never forward non-FQDNs` (which sounded like a good setting based on the name). However, it means the Pi-hole treats itself as authoritative for the domain name, and won’t go to the actual authoritative name server to pick up external records.

### Home Assistant
One final step: making it easy for everyone in the house to turn ad blocking *off*. We don’t use it often, but unfortunately there are some apps and websites that break if their advertising domains aren’t available. More often than not, it isn’t even an intentional "please turn off your ad blocker" nag screen, it’s just some page that doesn’t handle errors, or videos that hang forever, or whatever.

My solution was to use the Pi-hole [Home Assistant Integration](https://www.home-assistant.io/integrations/pi_hole/). This provides a password-free mechanism to turn off ad blocking, and it’s easy to access on any of our devices, or via voice assistant. I paired it with an automation that automatically turns ad blocking back on after 5 minutes, and IMO it’s been working great.

### Cold Spares
Now that my partner is WFH full time, having a reliable network is very important. I’m going to upgrade the software and keep the old hardware as spares that can be swapped in.

Worst case, I could simply re-enable the router’s DHCP server and use one of the several publicly available DNS servers, but having the spare hardware is cheap insurance and it'd be nice to keep blocking ads while I figure out how to fix things.

----

[1]: True, but with a caveat. I bought mine in July 2009. It turned out to be Revision A1, which isn’t supported by [DD-WRT](https://wiki.dd-wrt.com/wiki/index.php/D-Link_DIR-825) nor OpenWrt. I bought my parents the same router (but a later hardware revision) in 2011, which they outgrew years later and I took off their hands. So I switched to that physical hardware when I installed an alternative firmware, but I was using the same **model** for 12 years.

