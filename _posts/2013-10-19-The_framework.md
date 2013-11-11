---
layout: blog_post
title: The Framework
---
Today, I'm writing about what I consider to be a common anti-pattern in the enterprise development world, which is *The Framework&trade;*.
Simply put, this pattern manifests itself as the existence of a company standard, internally developed framework or set of components which everyone must use.

While I don't expect a (technology focused) company to get by without internal standards or a good amount of internally developed code, when that usually crosses the border into anti-pattern territory is when *The Framework&trade;* is an attempt at abstracting the underlying technologies with the aim of simplifying development for the masses, which is, in my opinion, a failure both in means and end.

The flaw in the means of such an approach is integration, since there is an effort to make everything work in the "optimal" way, thus hiding the flexibility of the underlying components.
Rather than a lack of developer ability, this is a reflection of the reality of the undertaking: you can't expect to pick a bunch of components, which have been developed over a significant period of time by many people, integrate them, and expect then to have the same robustness and flexibility for the whole as you did for the individual parts.
Not without significant time and money investment, at least.

Troubles then appear when, for some reason, you need or want to recover some "hidden" feature from the underlying components, since you'll either have to hack your way through or give up on that feature.

As I've written above, the reasoning behind this approach is also flawed, which is trying to make development easy for the masses.
To do that, *The Framework&trade;* is handed from high above to the helpless common developer, so that he can do his job without ever making mistakes, because *The Framework&trade;* does not allow for mistakes: after all, it's been handed from high above.
Glossing over the fact that it's borderline insulting, it's a move that effectively devalues most of your developers, who now have not only to learn your new proprietary technology when they come on board but are also wasting time learning skills which are useless in the job market.
Oh, and writing code to get around the limitations of *The Framework&trade;*.

As a closing remark, and as with most things software development related, thisis not always a mistake and there are times where a custom approach is indeed the best path to take.
Before deciding to take it, however, consider if the same thing is not achievable through simple configuration of existing components or automation.
Provide recipes and pre-cooked ingredients rather than finished dishes.
These will be much simpler to modify when (it is *when* rather than *if*) the need arises.
