---
layout: single
title: DNSMasq is My Favorite Router Feature
date: 2017-02-22 14:11:48
tags: [dnsmasq, ddwrt, network setup]
published: true
---

I've been running DD-WRT on my router for years. I don't remember why I first installed it. I suspect it may have been for the novelty, and because I was enamored with the sheer number of features it had. Features that, to be honest, I don't really need or even use. That has since changed. Here's why I currently rely on it.

# Dynamic DNS

I've been running some form of Dynamic DNS ever since my family made the jump from dial-up to DSL. From the beginning, it was DynDNS's free plan with one of their free domains. Then two things happened, roughly the same time: they eliminated their free tier, and I bought a domain.

So, I set up Cloudflare for my dynamic DNS. The router, running DD-WRT, uses a "DDNS Service: Custom" configuration to notify a web app running on Heroku, which updates Cloudflare through their API. The code lives at [e28eta/cloudflare-dyndns](https://github.com/e28eta/cloudflare-dyndns).

# Local DNS

Now that I owned a domain name, I wanted to start using it on the local, private network. I learned about Split-horizon DNS, and did my research. I was trying to use macOS Server (it bundles BIND) for the local DNS results. I wanted Cloudflare to remain authoritative for the public IP, but be able to override some of the entries and add additional ones for the private network. 

I didn't figure out how to do that with BIND. So I gave up on the idea.

## DNSMasq

As far as I can tell, DNSMasq is built to do exactly what I wanted: operate as a recursive nameserver, while also overriding or inserting some entries. I don't know why I didn't find it earlier. Maybe I skipped Google results that weren't about BIND. In any case, my determination to fix [the printer problems]({% post_url 2017-02-22-printer-discovery-using-dns-sd %}) meant I had another reason to run a local DNS server, and I finally learned what DNSMasq was, and what it offered.

### As DHCP Server

DNSMasq is also performing DHCP duties on the local network. It adds any DHCP reservations (dynamic and static) into the DNS results. That's pretty cool!  I'm grateful to the developers who've fully integrated it into DD-WRT's web UI. According to older blog posts, it used to be more difficult to set up, because it didn't allow DNSMasq to take over as the DHCP server. Instead, you had to coordinate between the two processes with some scripting.

# In Conclusion

There are other things I appreciate about my router with DD-WRT: Features that I use, like port forwarding and the firewall. The fact that it (probably) doesn't have a manufacturer's backdoor in it, and that it's still being updated. However, where it really shines for me are these four features:

1. Cloudflare Dynamic DNS, with a little glue in the middle.
2. Makes my printer discoverable through DNS-SD.
3. Easily extend & override DNS results for the internal network.
4. DHCP reservations are added to DNS.

Three out of four are enabled by DNSMasq, and that makes it a key part of my network setup.

----

PS: I am aware there are other open firmwares, and I believe I also looked at Tomato and OpenWrt years ago. I do not remember why I ended up with DD-WRT. I'm primarily looking for an appliance that does not need extensive care and configuration, and it has exceeded my expectations, so I haven't messed with it.

