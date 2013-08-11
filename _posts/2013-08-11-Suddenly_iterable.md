---
layout: blog_post
title: Suddenly, Iterable
---
I've had my first experience with Google Guava (the Java library) on the project I'm currently on.
The library is a special kind of useful in that, instead of providing some really new features to Java, it is mostly a collection of utilities which fill some gaps in the language's current API.

I was, however, initially struck by how often the API uses Iterable as an argument and return value.
Honestly, I don't think I'd ever seen it being used before.
Although I found it odd, I didn't give it a lot of thought because all the Java collections I know implement that interface, and all the JavaDoc for Iterable states is that classes implementing it can be used in *foreach* loops.

Until, a few days ago, I found myself looking at my own code and, suddenly, realized that Iterable is much more powerful that it looks.

The first thing about it, and the one that I like the most, is how it suggests composing your code as a series of filters, UNIX-style.
I mean, sets and lists are useful semantics for many functions but most of the time you're just transforming stuff into other stuff, which is what Iterable is all about.

The other, which is actually enabled by the first, is lazy processing.
After playing around with Haskell, I like being able to simply think in terms of action composition to reap benefits in readibility and let the lazy nature of the language do the optimization.
Iterable lets you do this: you just chain the function calls and their implementation uses whatever type of evaluation it prefers.
Again, you can do this with collection types but the builtin types for these are not lazy and it's much simpler to create an implementation of Iterable (one method) than of Collection (many more methods).

Finally, there are a number of libraries out there that take advantage of these properties to turn Java code into functional looking code, which, in my opinion, is a step forward.
For now, the syntax is awkward but, with lambdas promised on the next version of Java, it might make all the difference.
