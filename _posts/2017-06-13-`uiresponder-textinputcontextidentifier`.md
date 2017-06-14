---
layout: single
title: WWDC Sessions, and `UIResponder textInputContextIdentifier`
date: 2017-06-13 17:54:54
tags: iOS, apple, documentation, UIKit, WWDC, WWDC17
published: true
---

# WWDC

I love WWDC. The new announcements are thrilling, new APIs are fantastic, the sessions are incredibly useful, and the access to Apple engineers is unmatched.

I also find it frustrating, primarily because it only happens once a year and some of the best content is locked inside of videos. I'm particularly discouraged when a session covers APIs from a previous year and it's the **only** place that information is available.

A shining example: I've never found the official documentation that clearly delineates the constraint, layout, and draw lifecycle of views and view controllers. I have definitely watched (several times!) the WWDC session where an Apple engineer explains it, with diagrams and examples, tying together methods like the three `UIView.setNeeds...`, `UIViewController.view{Will,Did}LayoutSubviews`, `UIView.drawRect` (etc, etc), along with the order that the view hierarchy is traversed for constraints, layout, and drawing (it's not the same!). It was one of the early AutoLayout presentations. For a long time I had the lifecycle transcribed onto a whiteboard in my cube, both for myself and for explaining to coworkers. I don't have that whiteboard anymore, maybe I'll blog about it.

I know that [ASCIIwwdc](http://asciiwwdc.com) exists, and I love that it does. However I rarely, if ever, see it as a result in my Google searches. So I still consider WWDC video content essentially invisible.

# UIResponder textInputContextIdentifier

[The Keys to a Better Text Input Experience](https://developer.apple.com/videos/play/wwdc2017/242/) has a section explaining [`UIResponder.textInputContextIdentifier`](https://developer.apple.com/documentation/uikit/uiresponder/1621091-textinputcontextidentifier). But first, here is what the documentation currently says about this API that's been available since iOS 7:

> An identifier signifying that the responder should preserve its text input mode information.

> If you redefine this property and return a string value, UIKit tracks the current text input mode for the responder. While in tracking mode, any programmatic changes you make to the text input mode are remembered and restored whenever the responder becomes active.

Now, contrast that with the contents of one of the slides presented by Shuchen Li during the session, particularly the comment:

```
class ConversationViewController: UITableViewController, UITextViewDelegate {
    // ... other code ...
    override var textInputContextIdentifier: String? {
        // Returning some unique identifier here allows the keyboard to remember
        // which language the user was typing in when they were last communicating
        // with this person.
        // It can be anything, as long as it's unique to each
        // recipient (here we're just returning the name)
        return self.conversation?.otherParticipant
}
    // ... other code ...
}
```

She previously described the use case: the user wants to use an English keyboard for messaging their coworkers and a Chinese keyboard for communicating with their family.

I honestly think I could end this post right now, and my point would be made.

I had no idea this existed. Even if I thought it might exist, this property doesn't seem like the right one after reading the documentation. After the session, I looked around the internet for `textInputContextIdentifier`, and this is what I found:

* Google: on the first page there are links to the documentation for the property, headers for UIResponder containing the property declaration, a single StackOverflow result, and a tweet from @viticci that was *replied to* with information about it.
* StackOverflow: 2 hits. 1 user complaining about AppCode autocomplete suggesting `textInputContextIdentifier` when they want to type `text`, and a user trying to put the identifier into his CoreData model for unknown reasons (the answer to his question is his IBAction wasn't connected).
* GitHub: 38 code results for the property name in `.m` and `.swift` files, which at a brief glance look like they don't know what it does, or it's commented out, or often both.
* Apple Developer Forums: 0 hits.
* Twitter: 3 tweets, from 2 different people who **definitely know** what it does. All from 2015.

To be fair, I've never built an app that needed this behavior. I'm also not bilingual, so I've also never needed the behavior as a user. So maybe this is nearly invisible in the places I looked, but is commonly known elsewhere. I doubt it.

I think it's a problem that 4 years after a property was introduced, providing a feature that [some users love](https://www.macstories.net/news/ios-6-messages-now-automatically-selects-last-used-international-keyboard-for-each-contact/) to 3rd party apps, an explanation of that property is included inside of a 40+ minute video at the same time that *~130 other videos* are made available.

