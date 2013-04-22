---
layout: blog_post
title: Tests don't make you agile, they keep you agile
---
Since I follow many programming blogs, I stumble on the subject of testing from time to time.
And by testing, I mean automated testing.
It's not that I look down on manual testing but automated testing is the focus of this blog post.
I think I've heard all kinds of opinions, from "testing won't help you if you develop with care" to "testing is better than the wheel, fire and electricity combined".

My opinion, being into agile methodologies, is that testing can make a world of difference when done correctly but there are many ways to do it wrong.
The part where I think people don't completely get testing is why you should do it, and this is actually much more important than it might seem, since the reason for doing something should determine how you do it.

Proponents of Test-Driven Development will say that tests lead to increased software quality but that's not the way I see it.
From my perspective, tests make software degrade less over time.

Imagine the typical software development project kick-off: a team starts developing a program with a few features.
These features might be so few that most of the application's behavior can be tested manually in a few minutes so, at this point, testing is kept as a manual procedure or is not even officially done (which is, frankly, chilling).

The first release of the application is then successful and now everyone wants to improve it with new features.
So the application grows.

This might happen over a few releases, until, inevitably, bugs creep in.
Depending on your team's performance, they might be many or very few but they creep in.
And they keep creeping in because your testing team, which has been created in the meanwhile, doesn't have time to test everything and, unsurprisingly, they are real people and make mistakes sometimes.
Or, somehow, a critical bug shows up in a previously developed part of the application (which doesn't make sense because nothing new was added on that component!).

The project's development pace begins to slow down and costs go up but the problem is still there.
Should we ramp up our recruiting efforts to bring in more and better developers and testers?
Or maybe we should educate the ones we have, since they might not be sufficiently aware of the importance of quality.
Or, then again, it didn't make sense to create tests right from the start but now we'd really get some benefits from creating them!

Unfortunately, at this moment, the project might be doomed: all of the above options will probably result in increased costs (because you're either training people or starting to write tests from scratch) and decreased productivity (because training people and creating tests takes time from core development).

The point I'm making here is that tests should be a concern from the very beginning in the overwhelming majority of projects.
Rarely does a project live only to the first release so plan accordingly.
While I do think that, many times, "You Ain't Gonna Need It" (YAGNI), keeping test coverage at an acceptable level is very cheap and thus you break even on testing efforts very quickly and turn a "profit" from then on.

As all other things in software development, testing should not be a matter of philosophy but should be a conscious business decision.
Things like project scope and budget come into play when deciding how much, if any, testing is to be done.
