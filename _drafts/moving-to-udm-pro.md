---
layout: single
title: Moving to UDM Pro
initial_date: 2022-01-30 16:30:14
tags: [network setup,dnsmasq,ubiquiti,raspberry pi]
published: false
---


- brume not fast enough :(
- didn't want something with crazy antennae
- UDM Pro - finally get ubiquiti controller. no plans for talk, protect, etc
- SFP to switch only frees up 1 port per device, since switch only supports 1 GB
- read about running pihole in podman/docker; and letsencrypt support before buying
- after buying, decided to stay on supported SW (sad)
- No fucking usb port, need to change pihole
- moving to full rpi for ethernet
- still want spare setup/hardware, moving brume + pizero to travel router/adblocker
    - s/[all]/[pi0]/ for usb gadget instructions
    - edit `cmdline.txt` to remove `modules-load` 
- `pihole reconfigure` to move to eth

oh god it went all wrong
had trouble adopting both switch and AP
had to reset AP completely using mobile app
had to SSH into switch to do firmware update after it failed on GUI adoption, and then adopt via mobile app

no fucking cloudflare dynamic dns option
having so much trouble finding things in this UI


sudo apt install ddclient
sudo apt install libjson-any-perl

edit ddclient.conf with cloudflare settings
try `sudo ddclient --foreground`



piTft
https://learn.adafruit.com/adafruit-pitft-3-dot-5-touch-screen-for-raspberry-pi/easy-install-2#installer-script-2038256-6
installer script just adds to the bottom, but if there's a conditional config that doesn't apply to current board it doesn't work
ex: I had [pi0] (or whatever) for the usb gadget, and so on reboot it didn't work
Bug filed on github


next morning speed was *terrible*. couldn't even run speedtest from UDM Pro, it timed out

does not seem to be DNS/pihole problem, either routing or modem
plugged in directly to UDM, still having slow 

restart modem, back in business. Very suspicious, I haven't had to restart the modem in months
it was restarted just yesterday (accidental power plug pull)



installed:
kmod-usb-net-rndis, got the USB port working for router.

trying to get usbc working too:
kmod-usb-net-huawei-cdc-ncm
