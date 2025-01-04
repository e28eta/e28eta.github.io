---
layout: single
title: Internal search & Go Links
tags:
- development
- projects
date: 2025-01-01 18:25 -0800
---
When I started working at Stripe, I was on a team of new hires who did some work to re-vamp the internal search. These projects are small, well-scoped, and designed to be a quick introduction to development processes at the company, even if they have nothing to do with your day-to-day work. Which was certainly true for me, because it had little to do with the mobile development role I'd been hired for. However, I did find a feature to add that I remain proud of.

## Go Links in Search

Internal search ran on an Elasticsearch cluster, and it had a variety of data sources it would index: documents, wiki, people directory, etc. However, there was a parallel system used for content sharing: "go links". Throughout onboarding, we were constantly being given shortened URLs (ex: `go/some-words`), which led to the canonical location for whatever the `some-words` were. At least according to whoever had associated them together.

I realized this was probably the gold standard for search term relevance, and set up indexing of the go-link database. It made for very plain search results: the word(s), the url, and a little bit of metadata, but I think it made a big difference: it made the go links discoverable (within the limits of Elasticsearch's word relevance settings), and it augmented search results with hits that a human said "this link is the best place to go for this word or phrase".

I really liked the project, and found it rewarding working on internal tooling that people were using every day.

## Video conferencing links

My last shipped feature was another internal feature, and it was directly driven from the upcoming COVID pandemic. I'd given my two-week notice, and was about to start [funemployment]({% post_url 2020-03-17-funemployment %}). During my last two weeks of work, they announced an office shutdown. I'd done (what I think was) enough to hand off my "real" work, and was trying to find small pieces of work where I could continue to add value.

This was almost 5 years ago, and I haven't thought about it much since then, but to the best of my recollection:

Stripe was using BlueJeans as their video conferencing (the specific service isn't important). It had a feature to set up a short URL that'd lead directly to your personal video conference. At Stripe, employees were almost universally known by their username. However, the service was more restrictive than our usernames, meaning some employees needed a different solution. There were some people setting up ad-hoc Go Links to work around the limitations. This was actively happening in my last week as the entire company switched to fully remote work.

I honestly don't remember the specifics, but drawing on the experience I had from the previously discussed project, I quickly added a feature that let people link their Stripe username with their video conferencing identifier. It worked out of the box for most employees, and the ones who needed to customize it were able to.

I _think_ it was part of your customizable employee profile (where you could edit your name, pronouns, interests, location, etc), and I think it was used as `go/bj/<username>`. If that `username` had a customization, it'd use it, otherwise it'd just use the `username` directly. I _also think_ I put that link on the search result display for a Person, but I wouldn't swear to it in court.

I got it reviewed, deployed, and had time to write a Shipped email announcing it. If I remember correctly, that email went out late afternoon on my last day. I don't actually know how well it was received, but I had high hopes it'd be useful.

I also thought there was something poetic about starting & ending my tenure with internal tooling improvements.
