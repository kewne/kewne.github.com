---
layout: blog_post
title: When to do method call verification
---
Ironically, a few days after my post explaining why you shouldn't write tests based on method call verification, I ended up finding a case where it's not only useful but also the *Right Thing To Do&trade;*.

This came up after I reported [SPR-13615](https://jira.spring.io/browse/SPR-13615) and saw the patch that was submitted as a result.
The patch uses method call verification in the tests correctly because *the intended behavior is that the framework calls that specific method*.

This is something that I didn't think of because I don't usually write real framework code but, in hindsight, definitely makes sense.

Never say never, I guess.
