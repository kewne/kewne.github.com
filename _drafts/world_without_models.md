---
layout: blog_post
title: A World without Models
tags:
- design
---
TODO: Think of a good introduction.

# What's a model?

A model is a theory that determines what the relevant entities in a domain are
and attempts to explain how they interact;
as an example, classical mechanics is a model that describes the motion of bodies.


## Validity of models

Models generally have boundaries, i.e., they are valid for a specific domain but
not for all domains.

## Jargon

Models also generally include terms (words and expressions)
 *that carry a specific meaning within the model*, i.e. Jargon.

An example here is that both financial models and database models use the term
transaction, which mean different things.

# Why should software engineering worry about models?

## Think before you leap

One of the areas where, in my opinion, Agile and Lean have caused the baby to
be thrown out with the bathwater is design: my career experiences with trying
to "formalize" how a system is intended to work have generally been met with
cries of "over-engineering".

It's as if people are expecting to eventually build the Burj Khalifa by incrementally
improving off a wooden shed.

This is not to say that I support specifying system behavior to the smallest detail,
which incurs strongly diminishing returns;
I just think that, if software engineering were a race, it would be more similar to
the Dakar than Formula 1.

Another potential analogy is deep sea sailing...

## Composing models

## Debugging

Having a model can make debugging much easier because, given any "unexpected" behavior,
it can only be caused by either:
1. an error in the implementation of the model;
2. the model not being valid for that specific circumstance.



## Testing

With a model of how the system should work, it's easy to think of the cases to test.
