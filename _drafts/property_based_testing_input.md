---
layout: blog_post
title: Property-based testing &dash; Input
---
Some weeks ago, I wrote a blog post about property-based testing but talked only about how test cases are written and what they verify.

When talking about property-based testing, an important concern is that of input.
Although, in my opinion, input generation doesn't define property-based testing, it is the "special sauce" that makes it a really powerful technique since, if our test cases are valid for a whole input space, it's possible to run that test against every point in that input space.

Coming back to my string joining example from the last post, we can easily see that the `join` function can be applied to a list containing any strings, which makes the possible input space... infinity?

There are essentially three variables necessary to create an input sample:

* the size of the list
* the size of each string
* the character at each position of the string


Although, depending on the programming environment, these are actually finite, in practice, it is impossible to test the whole input space and still be on time for the next release, so we just sample the input space at random and test for that.

## Random generators

At this point, you may be thinking _if my input is generated at random, then the test might fail randomly!_ and, if you do, you are correct.
Repeatable tests are important because it's both a gazillion times harder to fix something you can't or have trouble reproducing and easy to claim things are "fixed".

Fortunately, the most common method of sampling is using random generators, which usually come in two flavors: truly random (usually used for cryptography) and pseudo-random.
The reason behind the pseudo-random name is that they generate sequences that are not truly random but instead follow a predefined sequence and, most importantly, *they can be reset to any step of that sequence*, which is called _setting the generator seed_ and makes it easy to reproduce problems.

Besides the nice features of this process I've already described, there's an extra: if you don't specify a generator seed, every time you start the input generation sequence, it will be at whatever value was already there so, over time, you'll have covered more and more of the input space and have more confidence that your code works properly.

## Adding preset inputs

In some cases, you might also want to make sure that certain inputs are guaranteed to run, like edge-cases or very common cases.
In this situation, you're able to specify those inputs and the test will run with both the preset and random inputs, making you reap the benefits of _both_ example and property-based tests!

## Input rejection

Depending on your domain model, it might be really hard to generate input that is appropriate for your tests.
For example, you could have filtering logic over a set of elements and a condition to return a special result if none of the elements are elligible.
While this could be done by generating a set obtained by joining a set of elligible elements and another of inelligible elements, it is far easier to just generate a random set of elements and evaluate if it's suitable or not.
