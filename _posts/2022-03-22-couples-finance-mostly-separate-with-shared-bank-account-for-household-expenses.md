---
layout: single
title: 'Couples finance: mostly separate with shared bank account for household expenses'
tags: [personal finance, accounting, splitwise, api]
---

We've successfully used [Splitwise](https://www.splitwise.com) to track contributions to a shared bank account, as well as payment of joint expenses from that bank account *and* by each individual.

# The Setup

My partner and I have not (yet) joined our finances. The money that each person earns and saves is theirs. I feel very fortunate that we have similar levels of disposable income, expectations for expenses, and (afaik) levels of responsibility. I suspect that'll change sooner or later, but there hasn't yet been a compelling reason to pool everything. In the beginning of our relationship, we mostly traded who would pay for things and never felt the need to be very precise about splitting things exactly equally.

Our situation *did* change when we purchased a home together. We decided to set up a joint bank account to auto-pay our mortgage & split large bills in half, and it quickly occurred to me that tracking who had contributed what would be complicated without the help of software. I've done a crash course on accounting once or twice, and had an idea of what I wanted.

* Expenses (mortgage, insurance, utility bills, etc) are paid by an individual, or from the shared bank account
* Direct Deposit contributions to the shared account were not in sync. My paychecks were bi-weekly, hers were twice a month (26 vs 24 paychecks in a year).
* Interest earned by money in the joint account is split equally for simplicity
* It should be easy for both parties to enter data and view balances

# Splitwise to the Rescue

[Splitwise](https://www.splitwise.com) looked really close. It has a free tier, mobile & web apps, and makes it easy to track expenses between friends. The only sticking point was the shared bank account. How to track the liabilities it owed to each of us?? Spoiler: create another Splitwise user to represent that account ([splitwise feedback site](http://feedback.splitwise.com/forums/162446-general/suggestions/3117255-shared-fund-for-house)).

Once I'd set up a Splitwise user named after our bank account and added it to our household group (2 people and the bank account), here are the common scenarios:

## Expense paid by individual

* Payer: the individual
* Split: equally between the people

![screenshot of add an expense page]({{ site.url }}/images/add-expense.png)


## Expense paid by shared account

* Payer: the bank account
* Split: equally between the people

![screenshot of choose split options]({{ site.url }}/images/split-options.png)

## Deposit by individual into bank account

* Payer: the individual
* Split: the bank account

![screenshot of choose payer options]({{ site.url }}/images/choose-payer.png)

## Interest earned by bank account

* Payer: multiple people, the people
* Split: the bank account

![screenshot of multiple payers]({{ site.url }}/images/multiple-payers.png)

You might be asking "**why** track the interest?" Especially since it amounts to maybe $20 a year.

I find it really useful because then the Splitwise calculation "amount owed by bank account" **matches** the balance of the bank account according to our bank. It's nice when the numbers reconcile accurately, and helps build trust that the amount owed by each person is accurate. It's helped find errors in amounts, as well as errors in the payer/split settings.

Interest is the use case that happens every month, but it also came in handy one time when we got an insurance refund check.

## How much of the money in the account belongs to each person?

With "simplify debts" turned off, the Group Balances -> "Bank Account owes $XX in total" is then broken down by each person.

![screenshot of group balances view]({{ site.url }}/images/group-balances.png)

(It's been a while since I've had a direct deposit in the account, and in the above screenshot *all* of the money and more in the account came from my partner. I've been making up for it by paying other bills)

# Next Steps?

Something that's been nice about this setup is that it scales well. The primary purpose was to equitably split the mortgage, but as we've gotten used to it, it has been easy to add any one-off or recurring expenses.

I suspect we'll have a shared credit card soon, which would make it even easier to split restaurants (etc). Instead of entering every meal (ugh, who has time for that?), just use the monthly statement to roll them up into a single entry that's split in half between us.

Before we know it, we'll have our joint accounts paying for everything that's shared, we'll work together on savings & retirement goals, and eventually erase the distinction between my money and hers. Until then, thanks Splitwise!

# 2024 Update

Late last year, Splitwise added limits on the number of expenses that a free account can add per day. We have _maybe_ 10 per month, but since we don't stay on top of it, this limit is painful. Not painful enough that we'd want to pay for a premium account ($5/mo or $40/yr), because there's no way we get that much value from it.

I found a reddit comment that the older Android clients don't enforce the daily expense entry limits. It turns out their publically documented API doesn't enforce it either. So I wandered over to https://dev.splitwise.com/ and entered almost a year's worth of expenses in an afternoon, using my [API client](https://paw.cloud) of choice 🎉
