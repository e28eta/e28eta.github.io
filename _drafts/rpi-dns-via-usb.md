---
layout: single
title: Raspberry Pi serving DNS via USB
initial_date: 2021-08-14 20:36:00
tags: []
published: false
---

1. Clean image of raspbian onto SD card
2. set up wifi + ssh: `boot/wpa_credentials.conf` and `boot/ssh`
3. startup rpi
4. change password (default `raspberry`), run `raspi-config`
5. Ethernet gadget via g_ether:
 - update `config.txt` with `dtoverlay=dwc2`
 - update `cmdline` with `modules-load=dwc2,g_ether`
6. reboot
7. install pihole software : `curl -sSL https://install.pi-hole.net | bash`
 - using `Cloudflare` as upstream
 - 10.10.10.3/23 network address on `usb0`
 - I think this breaks wifi connection :( maybe leave gateway blank? for my retry, setting static IP for wifi, will reset once things are running well
 - in practice, having it setup to join wifi network *and* using `usb0` may be helpful, since I can configure/update it while plugged into power somewhere else, and reserve the `usb0` interface for dns/dhcp service?
 
openWrt
- uboot web interface, uploaded `openwrt-21.02.0-rc4-mvebu-cortexa53-glinet_gl-mv1000-squashfs-sdcard.img` - after wondering which image was the correct one.
- seems to have successfully restarted into a clean, unconfigured openwrt image
- change password, configure ssh for lan-only and ssh-key only access
- need to connect router to internet for installing new software
- through web interface, System -> Software
  - "Update lists"
  - install `kmod-usb-net-rndis`, which includes required dependencies
  - `usbutils` because I've got the space
  - reboot the device
  - plug in usb gadget, `usb0` interface shows up
  - add it to the bridge ports, since I already had one
  - configure router manually - cribbing from previous openwrt, diff versions so no auto-apply
  - upgrade outdated packages: `dnsmasq`, `luci-app-firewall`, `luci-mod-network`
  - install `luci-app-ddns` and `ddns-scripts-cloudflare`
  - trying out `luci-app-ledtrig-usbport` for USB instead of VPN on LED
  
- `pihole -r` to change IP address, interface & turn on ipv6 dhcp/dns
- `sudo apt-get update` && `sudo apt-get upgrade` for anything that hasn't been updated since the imaging process

- add router IP + hostname to `/etc/pihole/custom.list` so that dnsmasq will serve it
