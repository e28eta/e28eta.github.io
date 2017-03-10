---
layout: single
title: Building Swift as a Newbie
date: 2017-02-02 14:37:18
tags: swift
published: true
reference: https://twitter.com/jtbandes/status/824667696541298688
---

# Checking out & building Swift, my experience

## Getting the Code
The instructions provided at [apple/swift/README.md](https://github.com/apple/swift/blob/master/README.md) work great for getting the code, and building it. As an iOS developer, I'm accustomed to using Xcode, so I opted to use `./utils/build-script -x` to generate an Xcode project. This takes **over an hour** on my late 2015 iMac.

This is supposed to be an incremental build. So I figure I'll see how much overhead there is. Running a second time, without making any code changes takes **30 minutes**. I think this is absurd, and it looks like most of the time is spent running some benchmarks. I'll have to look into that later.

This is where I feel like the documentation falls off a cliff. 

## Testing?
At the bottom of the README there's a link to [Testing Swift](https://github.com/apple/swift/blob/master/docs/Testing.rst) that describes how to run the primary test suite "for day-to-day work on the Swift compiler". The abbreviated version: `utils/build-script --test`. Whoops! There goes another **70 minutes** 🙁. Apparently, since the first build used Xcode, I need to keep using `utils/build-script -x`. Omitting `-x` causes the script to build with `ninja` so that it can test the ninja output. Well, as long as I'm here, let's see how long `utils/build-script --test` takes when it doesn't need to build the project first: **22 minutes**! Side note: No benchmarks seem to have been run.

Back on track. Since I'm planning to build with Xcode, presumably I should test with the Xcode products: `utils/build-script -x --test` -> **54 minutes** 🤦‍♂️. The benchmarks are back.

I have no idea why `-x` builds `swift-benchmark-macosx-x86_64` but the ninja-based build doesn't. However, looking through the ~500 lines of output from `utils/build-script --help` has two separate sections that reference benchmarks. `--skip-build-benchmarks true` looks promising. I tried looking at the implementation of build-script, but that didn't enlighten me.

`utils/build-script -x -t --skip-build-benchmarks true` -> **20 minutes**. This is not a fast feedback mechanism. I've probably been wasting my time, and should run the test suite rarely.

## Xcode

I've exhausted the documentation from the README. Now I want to find the Xcode project that was generated. In my case it was `../build/Xcode-DebugAssert/swift-macosx-x86_64/Swift.xcodeproj` How did I find it the first time? I don't remember. I might have looked around the file system until I found it, even though it's 3 levels deep in the build products directory structure (which is above the current working directory!). Maybe I looked through the thousands of lines of output from build-script, or used `find <dir> -name '*.xcodeproj'` on the entire swift source tree. Perhaps I had to do all three. Most recently, I was reminded where it was because I'm following some of the swift developers on Twitter.

Allowing Xcode to auto generate schemes results in **608** to choose from. To my knowledge, there isn't any documentation on using Xcode with the swift project. Good luck and have fun! &lt;/sarcasm&gt;

## Closing Thoughts

Honestly, this isn't the first time I've tried to get set up, and I've probably made the same "mistakes" each time. I'm also coming from *much* smaller projects (although I started my career working on a [10+ million LoC application](http://www.drdobbs.com/tools/building-quickbooks-how-intuit-manages-1/240003694)). So I don't mind admitting that  spending 2+ hours getting the code, compiling it, and running the tests to see them pass **before** attempting to make any changes is enough to make me quit. Several times. Why? I **cannot** believe this is the day-to-day workflow of swift developers, but I also don't know where to find a better workflow. I tried searching with Google, looking through the mailing lists, and reading the official documentation.

This took me all day (with plenty of distractions), and by the end of the day there are 25 new commits! Do I dare pull them, or will that cost me another hour waiting for the project to rebuild? (Addendum: **33 minutes** the next day for `utils/build-script -x --skip-build-benchmarks true`)
