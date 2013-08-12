---
layout: blog_post
title: The end of construction
---
One of the things that I enjoy the most in C++ (one of the few enjoyable things about it, really) is RAII.
For those who don't know, RAII (Resource Acquisition Is Initialization) is a pattern which uses object constructors and destructors to acquire and release resources.
This, along with C++'s automatic management of stack allocated variables, allows one to reap the benefits of the language's high performance and deterministic behavior while avoiding the classical C error of forgetting to free a dynamically allocated variable.

The reason that I like RAII as a pattern is that it is very natural once you learn it: you're telling the computer what setup and cleanup is required for that class to work.
Actually, I like the notion that, aside from normal operation, objects have initializers, which instantly leave the object in a usable state, and cleaners, which erase the object's footprint.

Ever since coming back to Java, however, I've been more or less angry with how much constructors are ignored.
I'm not even going to talk about destructors, since they don't even exist, but, in the almost two months I've been doing Java development, I haven't come across many constructors, which I find awkward.
I looooooove code semantics so, to me, code without constructors suggests objects that just appear out of thin air.
But, of course, objects don't appear out of thin air: with the exception of POJOs (another strange breed of "pattern", which I'm yet to wrap my head around), you'd be hard-pressed to find objects with no collaborators.
In this context, why then the absence of constructors?

Dependency Injection (DI), I guess.
Java is, to my knowledge, the flagship language for dependency injection.
There is a widespread awareness of what dependency injection is among Java developers: instead of declaring dependencies directly in a class's source code, you declare only dependencies on abstractions, with the real runtime implementation being supplied by a separate part of the application code/configuration.
This, together with the usage of field annotations, has effectively made constructors unnecessary, since you can annotate a field and have the DI framework populate it automagically.
And this, to me, is where the mess begins: code that is structured like this is not really loosely coupled in the way DI supposedly enables but is actually tightly coupled to the DI framework!
As a simple argument, try writing a test for a class implemented like this without the use of the framework and you'll quickly realize that you've effectively **locked yourself out of your class** (and no, you didn't gain much in terms of encapsulation).

Also, one of the most recognisable code smells, functions with too many arguments, breeze by more easily because you can just skip the constructor and inject 10+ fields into a class.
On the other extreme, classes with default or no-argument constructors are exactly what frameworks fancy: it's easier to generate code to instantiate a useless object and then call a lot of methods to get it to work properly than it is to figure out how to call the correct constructor with the right arguments.
Again, the semantics which drive code readibility are lost along the way.

On a final note, I'm not against dependency injection, as I find it important as a paradigm shift towards modular design.
I do employ the "inject everything into fields" technique in tests because test setup isn't really interesting, reusable or practical to do with constructors (I'm referring to the actual test class here, not the class under test).
I am worried, however, that constructors are being left out as a useful part of object oriented programming languages and design and, in particular, that the convenience of using a framework is outweighing the value of writing code that is correct and useful on its own.
