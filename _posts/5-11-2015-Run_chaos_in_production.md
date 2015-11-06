---
layout: blog_post
title: Run chaos in production
---
The project I'm currently working on is about integrating some webservices.
While developing in a service oriented architecture is convenient in many ways, it also requires a higher level of maturity in deploying and testing the intervening services, and needs to go beyond doing simple unit and functional tests.
Also, due to the relative stability of today's infrastructure, particularly in development environments where load is light, it's easy to overlook testing of the behavior of the system during failures and to underestimate the impact these failures have on the business.
This has prompted the appearance of a number of tools (of which Netflix's Symian Army is probably the most known) focused on causing failures by adding network latency, crashing application nodes and others.

For the above reasons, I've decided to run some experiments using Vaurien a (now seemingly defunct) TCP proxy developed by Mozilla.
Vaurien essentially supports two modes:

* remote controlled, where it launches a HTTP server and allows you to set the desired behavior;
* static configuration, where you set the configuration on launch and it stays the same forever.

There is a nuance in these two modes, in that static allows setting behaviors like "X% of requests will hang AND Y% will be delayed by T time" and remote control only supports "hang all requests" or "delay all requests by T time" (there isn't a way to mix behaviors).

To set up the chaos environment, I used Docker, since the service I'm working on is already deployed that way and there is a Vaurien image too.
Vaurien is also limited to a single proxy per instance, so I effectively had to run three separate containers (one for each service my application depends on).
This was a bit annoying because each of those containers requires the HTTP port to be exposed, so it's three more ports that have to be configured (or six, if you can't use container links).

Now came the hard part: what kinds of tests can I actually do with this?
As it turns out, not a lot: the only tests (as in automated) I ended up using are simple "block the network for a couple of seconds and unblock" ones.

So much for chaos.

This is because chaos injection is essentially at odds with the automated testing requisite of determinism (few things turn a healthy team of engineers into a mob of witch doctors faster than tests that only fail occasionally).
Ok, if chaos is not useful in tests, what can you do, then?

The same thing Netflix and others are already doing, *create chaos in production*.

This was my main takeaway from the experiment and, in hindsight, it was sort of expected: chaos should be random, to make sure that it hits the weak spots in your infrastructure's armor and brings the pain forward.
It also poses a new challenge: how do you convince the non-technical (and even some technical) staff to let you break stuff in production, potentially harming business?

While I'm not actively working on this anymore (gotta get actual features out the door!), I'm certainly going to pick it up again and continue to write about my experience here.
Have you done chaos engineering?
What has your experience with it been like?

