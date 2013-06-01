---
layout: blog_post
title: Continuing Android Development
---
Today I finally completed my first minimally complete Android app!
It is a [white noise machine](http://en.wikipedia.org/wiki/White_noise_machine).

So far, it is very minimalistic in terms of features:
1. It produces white noise;
2. It has a play/pause button.

On the technical level, it has a single activity which, as expected, manages the UI interactions, and a bound service running in a separate process, which generates the white noise and plays it.
For generating the noise, I'm using the AudioTrack class and setting markers to call buffer refilling events.
I'm yet to understand how these events work though.
The documentation isn't particularly helpful for this (the markers are supposedly set in frames but the concept is not explained anywhere) and there aren't a lot of people trying to do similar things, so I've basically been doing some educated trial and error with buffer sizes and the markers.

Writing the basic UI interactions, creating a service on a separate process and then managing the interprocess communication was surprisingly simple.
It was also very well documented overall (other than AudioTrack), with very few googling for things.
Another strong point was the icon library, which can be downloaded for free and is invaluable for design impaired people like me.

Planned additions to the app so far:
1. Add colored noise options, like pink and brown noise;
2. Optimize memory and battery usage on noise generation.

I'll keep reporting on my progress, especially because I'm also thinking about releasing it on Play when it works a bit better.
