---
layout: single
title: Campaign Notes as a Player
date: 2020-09-03 15:40:00
tags: [d&d, obsidian.md]
published: true
---

I recently started playing D&D again, after a *long* hiatus. I got very excited about it and wanted to take robust notes, but didn’t know how to best approach it. I’m currently trying two things: a narrative journal of our sessions, and an encyclopedia of everything notable from those sessions. I did a broad search of campaign note software, and found a variety of suitable looking stuff, albeit mostly targeted at the Dungeon Master.

It’s an interesting challenge trying to find software when you don’t know what it’s called. Even more so when I didn’t know which features would be most important to me. I found a bunch of candidates, but I feel really fortunate that I stumbled onto [Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten) software, specifically [Obsidian.md](https://obsidian.md).

# Obsidian

> Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files.
> In Obsidian, making and following [[connections]] is frictionless.

"Powerful knowledge base" and "frictionless" are very general claims. What do they mean, and how accurate is it?

I believed I was looking for personal wiki software. I wanted to create a set of pages, and interconnect them. I also wanted to be able to put them into hierarchies. I’m also somewhat spoiled by the editing experience of IDEs. Obsidian delivers, and it’s free.

* Links: it is easy to build a wiki-like encyclopedia with many inter-page links, and navigating links during editing is just a cmd-click
* Creating/editing pages *is* easy: files are auto-created if needed, and unlike a typical web-based experience there’s no edit/save cycle.
* Markdown formatting makes for simple formatting, and the editor does what I expect. For example, surrounding selected text with formatting characters, instead of replacing the selected content.
* Quick navigation: open files by names
	* Bonus points that this supports the type of matching I’m used to from Xcode. Matches all files that contain the characters entered in the order they were entered, with any insertions allowed.
* Auto-completion of links. The app knows the name/path of every `md` file and will use that for an auto-completion list when creating a link (same as open by name)
	* It **also** updates links to a file when it is renamed inside the app
* Uses markdown files in folders
	* I can build my own hierarchy, and the auto-updating of links means I can evolve the hierarchy as needed.
	* Makes it easy to version control & share via git. Even for a personal project, I like a version history & the ability to leave myself commit messages.
* Images shown in preview mode. I don’t have many images (yet?), but it’s nice for maps
* I haven't made much use of tags yet, but they look useful as I want to create additional connections/correlations between entries.

It does have some problems, but so far they’re minor annoyances. Like the fact it’s cross-platform software, and doesn’t get everything right for Mac software 😢. Or the fact that I find the multiple editor panes annoying to control & difficult to achieve what I want with them.

I’ve done some file editing via [Working Copy](https://apps.apple.com/us/app/working-copy-git-client/id896694807) on iPad. I **did** miss features like auto-completion of links and renaming support, but it’s workable.

# Other Approaches

Without good linking & navigation support, I might prefer fewer documents. Instead of very granular articles, I’d be tempted to co-locate a lot of information, making it easier to read/browse and use `Find` within the document.

Another approach is a structured database. Define different entity types, and required/supported fields for each. I think this is more likely to be useful for a DM. As a player, I know very little about each new thing, but as the game progresses I’ll learn more. Compare that to the DM, who might want to (for example) be able to see all the priests of a various deity, and gets a lot of value out of structured data.

Native vs web. I’m transcribing a session’s worth of notes at a time. This means a large batch of changes across the whole encyclopedia at once, and reducing friction is important. I think it’ll be nice to see all those changes together, instead of just versioned changes to each entity. It feels very natural for this to be a native app. As a developer, I’m very familiar with git, and so are most of the other people I play with. This started as a personal project, but if I share it with the rest of the group I may end up regretting excluding our non-technical party member (or I’ll need to figure out some way to make it accessible to them).

Using github gives me authn/authz for free, as well as great uptime and sharing. But there’s no way it scales. If I had multiple editors, conflicts would be a PITA. Plus the huge barrier to entry that git has.

I haven't spent much time evaluating other Zettelkasten software (like Roam), but I suspect they'd meet my needs similarly. I like that Obsidian is free and I control the storage/syncing of the data store, so I probably won't be looking for a replacement anytime soon.
