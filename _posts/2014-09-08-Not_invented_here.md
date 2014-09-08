---
layout: blog_post
title: Not Invented Here
---
Not Invented Here (NIH) is a well-known expression for software developers and describes a general attitude which favors developing software in-house, rather than reusing or adapting existing tools.
Today, I'll try to list some pros and cons of this attitude, based on my opinions and experience so far.

Disclaimer: this is by no means an unbiased analysis.
Although I try to be impartial, I believe that reusing existing components should *always* be your default option, especially nowadays when there is a lot of free (as in freedom) software.

Pros of NIH
---------------

### Control

This is one of the main reasons for developing in-house, and one which I think is understandable.
The idea is that, by not being restricted by or being outside the influence of external entities, progress becomes more predictable.
Indeed, I've had instances where I had to chase customer support from one of our suppliers for some weeks to get simple questions answered.
Even when support is responsive, the mere delays involved in exchanging emails or other communication channels can add a meaningful cost to your project.

### Lack of in-house expertise in third-party tools

This one I just can't understand but, unfortunately, seems to be very common and somehow gets a lot of traction.
It is usually coupled with "our version will boost productivity because it is much simpler and limits the developer's ability to make mistakes".
Although the expertise required to actually develop the solution is very high, the advantage is that the requirements for everyone using the tools lowers.

An analogy for this is how highly skillful engineers design a manufacturing process that any factory worker can then apply.

### Cutting Edge

Every once in a while, some big tech company will open-source or talk about a particular in-house developed technology they use.
This usually happens because the state-of-the-art in that field was not fulfilling the company's needs, so it made sense to go ahead and develop it.
In my opinion, this is the best way to apply NIH reasoning, since the alternative is to compromise with existing tools.

Cons of NIH
----------------

### Reinventing the wheel

More likely than not, someone else has probably solved the problem you are solving.
If that solution is readily available, why waste time and resources re-implementing it?
Reinventing something is valuable only if used as a learning tool.

### Lack of in-house expertise in the domain

This is a consequence of the high expertise required for actually writing a quality tool.
Setting out to develop a JavaScript framework when people in your company have little experience in the language might be educational but also very likely to cause more problems than it solves.
Of course, your people will (hopefully) become better acquainted with the problem and can refine the solution later on but then it might be too hard to fix early mistakes.

### Cost of training / Non-portable skills

Unless you open-source/sell your in-house developed solution and it catches on, you're practically guaranteeing that you won't find talented people with experience in your solution, and thus making the cost of on-boarding new employees rise.
To add insult to injury, when there is an alternative to your solution, you're paying a cost of opportunity too, since you could actually save on training (and potential mistakes) by hiring people with experience in that other technology.

Deciding whether to go down the NIH path
--------------------------------------------------------

Despite what I wrote at top about reuse as a default, I do believe NIH can be healthy.
At some point, it's better to break from the pack and build it yourself than to settle for something that doesn't fit your needs.
Realizing whether your needs are being met (or, conversely, if this new solution will meet your needs better) or not can be tricky though: sometimes it's hard to backtrack enough on the conventional ways to understand what needs to change and, even then, it's not obvious what the correct way is.

As a rule of thumb, I think the following are appropriate guidelines when deciding whether to give into NIH thinking:

1. Don't do it until you've *tried* whatever else is out there.
Reading comments and books about something isn't trying it, you need to build something and try some edge cases to get a real feel.
1. If you can't demonstrate a problem, fix it only if it's trivial to do so. Otherwise it's not real.
1. If you're going to do something, ask yourself "How much can I get away with not doing?".
Many tools today are extensible, you don't have to write everything from scratch.
1. Be ready to reevaluate your decisions.
New tools appear everyday and it might be cheaper to throw away your in-house solution.
