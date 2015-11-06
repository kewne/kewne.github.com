---
layout: blog_post
title: Property based testing
---
Explain property based testing:
Property-based testing is essentially a way of asserting a certain property of a piece of code that holds for a whole category of inputs.
This is opposed to example based testing, which uses the same finite set of data points.

Give an example.

In practice, property-based testing uses a finite set of points (because testing for the whole input space is prohibitive) but these are usually generated randomly.
Sometimes also uses input reduction, which is the narrowing of inputs to identify the simples cases that produce failures.

Property-based testing relies on constraining inputs.
When constraining is difficult, you can use assumptions to ignore failures.

The advantage of property-based tests is that, due to the lack of control over the inputs, it's harder to write incorrect tests that pass.
Besides, since inputs are randomly generated within a given range, tests that continue to pass over time give you even more confidence the code they test is correct.
The disadvantage is that it's sometimes hard to correctly constrain the inputs to cover specific scenarios.
For slow tests, testing over large sets of inputs can also become a problem.
