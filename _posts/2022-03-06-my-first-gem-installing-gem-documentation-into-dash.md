---
layout: single
title: 'My First Gem: installing gem documentation into Dash'
tags: [documentation, development, ruby, bundler, dash.app]
date: 2022-03-06
---

I've been a long time user of [Dash.app](https://kapeli.com/dash). Most of my professional development happens on iOS, and Dash + [Alfred](https://www.alfredapp.com) worked their way into my workflow, even though I was previously entirely satisfied with the built-in Xcode documentation viewer. My passion / desire for code documentation goes back to the days where I'd added [appledoc](https://github.com/tomaz/appledoc) generation to our Xcode builds & was publishing a docset of our application code through CI. To this day, I don't know if the handful of other devs on the project used it, nor whether it remained working for very long after I left (which yes, I know means it was probably a bad use of my time, although I _think_ the build failures for missing documentation were a net positive).

With that said, I've been less impressed with Dash as soon as I left the Apple documentation. This includes moderate usage of 3rd party libraries. It's not necessarily a fault of the app, but more an expectation from me that I shouldn't have to manage documentation. When you're doing mostly vanilla Apple frameworks, enough functionality is built in. Apple's documentation, while sometimes badly lacking, does a fair job at marking API availability and it's possible to use the latest SDK to develop against older versions of the OS.

What I _really, really_ want is to be able to view all the documentation for a project, and only the documentation for that project. Dash has "Search Profiles" that can be manually managed: adding / removing / updating docsets, and making it easy to constrain a search to a specific profile. I've done that when I primarily work on a single project: here's the iOS docs and here are the handful of libraries it currently uses, which are updated infrequently. It 99% does **not** work for random projects that I find and want to make a change or two to. I have been super frustrated trying to poke at random Ruby projects, and trying to look up symbols. I think some of the problem is that other ecosystems are pretty granular, some that they publish a new docset for every minor revision, and (at least with Ruby) some that when classes are extensible there are *too many* results (right now, searching 'ruby: string' gets **19** results on my machine).

Just over two weeks ago, it occurred to me that there might be a better way. What if I could programmatically update a search profile, and have it match a project's dependencies?

Unfortunately, Dash.app doesn't expose the required APIs. You *can* ask for a specific docset & version to be installed, but that's the extent of it. I've emailed with a feature request to do more, and the developer says it's on his todo list.

## Bundler

While I was looking for a pre-existing solution, I found a ~10 line [ruby script](https://gist.github.com/invalidusrname/c82915bc3596f265bda71a67006d20fe) that installed all the documentation for a project's gems, using `bundler`. I was able to make an [immediate improvement](https://gist.github.com/e28eta/0df41538eca1dc8b286c7d5b6d6072ed): using `open -g` so that it didn't bring Dash.app to the foreground every 3 seconds.

I'd like to think I've improved it further, in my [very first gem](https://rubygems.org/gems/bundler-install_dash_docs), `bundler-install_dash_docs`:

- reads the bundler lockfile instead of executing `bundle show`
- properly escapes url parameters
- properly handles shell / system command
- adds additional execution modes: dry-run, different verbosity options, all gems vs only dependencies

This is written as a bundler plugin, because bundler is "the" dependency management solution for Ruby. Right now it requires user action, but in theory it could be done automatically if the plugin is installed: download new version of gem && install new documentation into Dash. As a visitor to the ecosystem, I'm not sure what a perfect workflow looks like. However, I have visions of a single command loading up all the documentation for a single project, and making it searchable while excluding anything else installed on the same machine. This isn't a bundler-specific solution: I'd immediately want the same thing for any language / ecosystem with versioned libraries that Dash knows how to fetch documentation for.

## Unsupported Hack?

I poked at Dash.app: the custom url schemes, the (basically empty) Applescript dictionary, and concluded anything else was impossible at this stage. That's dumb, because Dash obviously stores the Search Profile information _somewhere_, and with enough effort it should be possible to edit it. On my second try, I found it in `~/Library/Preferences/com.kapeli.dashdoc.plist` (I think it's odd most of the data is stored in `Application Support`, but this is in `Preferences` 🤷‍♂️).

I've probably scratched my itch sufficiently for now, but it's tempting to go further.

## Other languages

Why bundler? Because that's what I was using when this occurred to me. Any combination of "versioned dependencies" and "robust Dash support" would benefit from something similar. Should it actually be a plugin to each dependency manager? Or is a Dash user going to want to install one tool that works similarly across ecosystems? (As I write that question, I feel like the answer is obvious, and *not* aligned with my current work. Oh well).
