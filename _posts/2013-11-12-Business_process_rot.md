---
layout: blog_post
title: Business Process Rot
---
As a developer, I'm very familiar with the concept of code rot.
It's a principle that draws a parallel with rotting food, which illustrates that code which is not maintained gradually falls into a state of decay and is rendered useless.

However, for businesses, there is another kind of rot which can accumulate, sometimes silently, which is business process rot.
Simply put, business process rot appears when a business process is not updated or maintained, resulting in something that is eventually out of touch with reality.

For example, imagine you're running a billing department.
You deal with invoices in EUR, get paid in EUR and all goes smoothly.
Suddenly, you begin to do some work abroad, and start getting paid not only in EUR but also in USD.
Clearly, some exchanging must be made so that all the financial reports match both in EUR and USD.
However, there isn't a clear policy for defining the exchange rate when billing in a currency other than EUR, so there is a lot of variation in how it is done.

Things like these can go on for a long time because, as the ingenious human beings that we are, we cope reasonably well with heterogeneous input and are able to fix things.

The problem: **machines don't cope well with heterogeneous input**.
They aren't able to make judgment calls and handle exceptions they've never seen before, so any little whole in a business process applied to an application instantly becomes an inflexible obstacle.

As a developer, I've found myself in several situations where the business process was not clear, which was not a good place to be in because, most often than not, it was up to me to fill in the gaps.
Even with all the widespread information on the importance of having cross-functional teams to develop an application, it is all too common for a developer to have to research himself the ins and outs of a business process, rather than having a specialist in that area explain the rules to him or at least guide him to collect all the information.

To finish, although all this talk might seem like I'm suggesting some kind of waterfall process or blaming the business side of development, I see it more as a specialization issue: can it be expected of someone in your company to master both the development and business sides of things?
My opinion is that, for any serious business, this can't be realistically expected, which naturally leads to a need for continuous business process refactoring, parallel to technological refactoring.
