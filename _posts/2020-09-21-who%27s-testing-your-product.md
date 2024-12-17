---
layout: single
title: Who's testing your product?
date: 2020-09-21 12:10:11
tags: [testing, qa, development]
published: true
---

This opinion is shaped by my career path: at Intuit with a QA team I enjoyed working with, and then working at Stripe without dedicated QA. This particular iteration is being written as a response to a HN comment thread about whether or not companies should *have* employees dedicated to quality assurance, and the claim that leaving quality in the hands of the dev team leads to better outcomes overall.

----

I assert that the engineer who codes a feature is **not** going to find bugs that they never even considered. It’s in one of their blind spots.

Sure, they can write some automated tests. They might even get 100% code coverage. But the bug that doesn’t have any code to cover it is unlikely to occur to them while writing test cases and their inputs. It might, if (for example) they’re writing boundary condition test cases and realize they forgot to check boundaries in the code. It probably won’t though, that’s why the bug is there in the first place. It might be attributable to the size of your codebase, and the complexity of the change. Also consider their experience level, both as an engineer and with this particular codebase.

They probably did their deep thinking at the beginning of implementation. They’re coasting downhill at the end, just trying to prove that the code does what they wanted it to do (TDD doesn’t change this). Maybe they’re already thinking about the next ticket, or who to assign the code review to.

----

Okay, you’ve got a bug or defect. Who’s going to find it? And what will that cost you? Conventional wisdom says the earlier in the development cycle that a bug is caught, the less it costs the company. Bugs also have different severities. I’ve chosen to work at companies that build software for businesses, and some bugs have direct financial repercussions for the company or our users if the bug reaches production.

Customers are good at finding bugs. They’re (hopefully) using your product regularly, and (probably) in ways your dev team never considered. You might build systems that use a phased rollout and monitoring to detect problems in an automated way. You might have a set of beta customers with a more direct line of communication to the dev team to respond to issues faster, and prevent them from reaching your entire customer base. Those customers are still subject to any ill effects from your bugs, and they’re not going to be very understanding if you corrupt their data or prevent them from issuing paychecks to their employees.

How do you catch bugs prior to production? I’ve seen a variety of techniques and names. To be extremely reductive: by having an employee use the product in a way they think the customer will. They have varying levels of formality and thoroughness. You might have employees dogfooding the product or host bug bashes. Did you set up processes to make it easier to report bugs because the cost/benefit ratio of reporting problems to other teams was too high? You might discover bugs while demoing the feature (low stakes: during sprint review, high stakes: to senior leadership or at the company all hands). Maybe the product manager sets aside time to do their own testing.

I think these are all valuable. My main concern is that they’re largely undirected and ad-hoc. Perhaps a bunch of people checked negative numbers, but your company isn’t diverse enough to have someone who tried on an iPhone set to use the Hebrew calendar. They were almost certainly unable to test on a leap day, or during a daylight saving time change. How many of your employees are moving real money through the product, compared to looking at abstract numbers on a screen? I think you’ll find lots of shallow bugs, but deeper bugs are more likely to escape detection.

What about code review? Does a second engineer reading the code for the feature help? Absolutely. A knowledgeable team member can certainly identify problems. However, I think this is influenced by the company culture toward code review, and what the stated purpose is. For example, if your "How to Code Review" documentation says "code review is not meant to find bugs", you’re going to have a problem. Or if code review is seen as a formality, perhaps mandated for compliance reasons (ex: prevent lone bad actors from inserting obvious backdoors).

Even with a thorough review, in my experience, it’s **hard** to see what *isn’t* there during code review. You’re almost always looking at a diff of the changes, and focusing on what’s been added. If the PR deletes code, you have a chance to find regressions by looking for edge cases that used to be handled, and finding where the new version handles that edge case (or doesn’t). What can you do about the edge case that’s mentioned just out of view in the diff tool, or never even hinted at in the code? I think it takes a mindset shift and a higher level of thinking: what is the problem being solved, what are edge cases I can think of, and have they been addressed? I love reviews by engineers who take the time to do this, but it takes extra effort and is aided by experience (ex: if you’ve never run into a DST bug, good luck finding one). It’s hindered if your PR description is just a link to the bug tracker and all your commit messages are noise, or if deep and thorough reviews aren’t reinforced by the organization and team. It’s also less likely to surface issues due to interactions with components owned by other teams.

----

I believe this is the real value of having someone dedicated to assuring the quality of the product. A second individual poking at a feature’s implementation whose incentives are tied to making sure it works right. Someone who’s considering "how can this break" from the beginning, instead of "what do I have to do to get this working". Someone with a wider and deeper perspective, who’s focused on being an expert in the weird interactions and darker corners of the product.

Pair programming might be a reasonable alternative to a separate role (I don’t know). I like that it adds a second person thinking deeply about this particular problem, which I think is key to high quality. And a pair with different experience levels could benefit from both the experience to avoid subtle issues and the increased collaboration driven by questions and explanations.

Every bug is different, and every company is different, so I’m not saying every company needs a QA department. However I think it’s important to consider how you’re filling their role (or not!), and what that’ll cost. If you lose someone’s progress in a game, that’s one thing. If you ruin someone’s business, that’s a completely different level of bug.

As your product grows in scale, the potential impact of a bug grows too.  I think this should lead to increasingly risk-adverse organizations. How you choose to manage that risk is a complicated decision. I really like the idea of explicitly paying specific people to ensure the product quality improves.


