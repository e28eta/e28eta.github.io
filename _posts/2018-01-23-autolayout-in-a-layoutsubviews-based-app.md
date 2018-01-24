---
layout: single
title: AutoLayout in a layoutSubviews-based app
date: 2018-01-23 22:39:41
tags: [iOS, AutoLayout, manual layout, layoutSubviews, UIKit]
published: true
---
# Manual Layout in `layoutSubviews`
The app I'm working on has a pattern for doing view layout that I haven't worked with previously: the `UIView` subclasses calculate their children's frames, from scratch, every time `layoutSubviews` is called.

It gets the job done and is reasonably straightforward to read, although slogging through the frame calculations can be tedious. It has the benefit of being maximally flexible, without needing to map concepts into springs/struts or AutoLayout constraints.

# AutoLayout
I personally prefer to use AutoLayout. I really like some of the concepts provided: intrinsic content size, compression resistance, content hugging, relative priorities, inequalities, etc. Those concepts make it (relatively) easy for the size of the contents to (implicitly) drive the sizes of the containing views, and provide tools to specify what should happen when things *don't* fit.

I'm a proponent of Dynamic Type support, and in my opinion AutoLayout makes it easier to write a responsive layout that adapts to changing content sizes.

# `translatesAutoresizingMaskToConstraints`
When AutoLayout arrived, so did [`translatesAutoresizingMaskToConstraints`](https://developer.apple.com/documentation/uikit/uiview/1622572-translatesautoresizingmaskintoco). I knew it as the property that made manual layout work with AutoLayout, and as a very annoying property that has to be set to `false` on *every* programmatically created view before adding the desired constraints to it.

Previous apps I've worked on have relied heavily on Interface Builder, because their UIs have been a good fit for IB. Also,  once we started using AutoLayout, we went through and converted everything to use it. So I'm learning some new intricacies about working in a mixed-layout codebase.

## Paging Scroll View + `layoutSubviews`
The codebase has a `UIScrollView` subclass that takes an array of pages, and provides paged scrolling through them. This one has a small fixed number of pages, so it doesn't need to implement view recycling (which I've written in the past), and is reasonably straightforward.

In the interests of expediency, I was planning to keep the layout code as-is, and just document it a little better. At the core, it was really simple:

```swift
func layoutSubviews() {
  super.layoutSubviews()
  
  // position the scrollView & update its contentSize
  scrollView.frame = bounds
  scrollView.contentSize = CGSize(width: bounds.size.width * pages.count, height: bounds.size.height)
  
  for (idx, page) in pages.enumerated() {
    // put each page in the right place, with the right size
    page.frame = CGRect(origin: origin(of: idx), size: bounds.size)
  }
  ...
}
```

However, I was having some layout issues. There were translated constraints that weren't what I wanted or expected. So, I tried `view.translatesAutoresizingMaskToConstraints = false`, to see what would happen.

## `view.translatesAutoresizingMaskToConstraints = false` && `view.frame = ...`
`setFrame:` (effectively) becomes a no-op! What? Why? Because setting the frame **updates** the translated constraints. Without those constraints, there's nothing to change. My (incorrect) mental model was that I could opt the view out of AutoLayout completely by setting the property to `false`.

It makes total sense that it works that way. I just hadn't thought about it too much, and had never needed to know. [WWDC 2015 Mysteries of AutoLayout, Part 2](https://developer.apple.com/videos/play/wwdc2015/219/) covers the problems I was having.

## Need to set an `autoresizingMask`
My new codebase does not use `autoresizingMask`. Why would it? The overrides of `layoutSubviews` provide full layout information, so there was no need to provide that info.

However, these views *are* creating constraints, which can either conflict or otherwise interact poorly with the rest of the screen. According to the docs, the default value for `autoresizingMask` is `.none`: none of the margins can change, nor the height or width! Not at all what I'm looking for.

I believe I'll need to populate the `autoresizingMask` on all the views that continue to use manual layout.

One of the ramifications of the original technique is that after `super.layoutSubviews()` has done all the work to figure out a solution to our layout, each of those calls to `setFrame:` has the potential to dirty the layout & require another pass of the AutoLayout constraint solver — especially when the `autoresizingMask` doesn't correspond with our desired frame.  I was seeing very few calls to `layoutSubviews`, so I don't think this was happening here.

## Or switch to AutoLayout
In the end, I actually chose to replace the manual layout code in this class. It was really easy to just stick all the pages into a single `UIStackView`, and constrain them to be the same size as the `scrollView`'s container.

Now AutoLayout knows the page contents influence the size of the containing view, and there won't be any surprises for the constraint solver mid-way through the layout pass.

