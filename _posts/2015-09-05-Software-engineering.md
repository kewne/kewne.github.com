---
layout: blog_post
title: About Software Engineering
---
Every once in a while, I try to take a step back and analyze my profession, software engineering.
I've been doing this over the last few weeks, the result of which is a three component model of software engineering.

# Why a model of software engineering?

First of all, why would a model of software engineering be necessary?
For me, the motivation for having a model of something is to provide the foundation for reasoning and discussing about that something.
My goal is not for the model to be necessarily accurate, rather a convenient reference for conveying my view on the discipline.
I have no scientific research or anything behind this, it's really just my opinion.

# The components of software engineering

The components of the software engineering discipline, as I see it, are three:

* Programming
* Patterns
* Architecture

## Programming

The programming component of software engineering is a low-level one and it directly relates to the code writing portion of developing a software solution.
The reason this is a component is that it is the building block for the other components, while being itself indivisible.

I like to think of this component as an analogue for the material from which a piece of furniture or a physical device is made, since I find many parallels between their properties.
These properties can be split in two categories:

* "Tangible" properties like complexity, method length and other metrics, that mimic physical properties of materials like compressibility and electric resistance
* Intangible properties like readability and style, that mimic color and texture.

## Reusables

The reusables component is sort of in the middle of the other two components, although I don't consider the relationship between the components as layers.

This components' naming reflects its concern with reuse: it builds on arrangements of the programming component that can be reused.
Related to this component are software programming patterns, libraries, frameworks and even platforms (Node.js or the JVM) or software applications.

What I find particularly interesting about this component is how it feeds upon itself, in that an application can be composed of several libraries on a given platform, or a library can be composed of other libraries and glue code.
If you drill down any of the solutions in the scope of this component, you would eventually come to a solution that is completely built on the programming component.

Also, a lot of heterogeneity can be found in this layer, making it hard to compare concrete measurements for properties because they easily become apples and oranges comparisons.
To make the analogy, these are essentially tools that can be used for getting the job done, and there are so many of them that two or more can be used for the same purpose, with the difference sometimes coming down to personal taste. 

## Applied Architecture

This component is what ties the other two to the business requirements.
The reason I don't view the model as layered is that this component acts more like a recipient, with both reusables and/or programming filling it.
This is what swayed me from considering a layered model, since programming often acts like glue between reusables, and architecture is what decides the mix of those that solves the business problem (fills the recipient).

The difference between a solution in the scope of applied architecture and in the scope of reusables is that applied architecture is meant to directly fulfill a business goal (which is why I named it "applied"), while reusables are meant as a stepping stone for getting the job done quicker.

# Summary

In this post, I presented my view of the discipline of software engineering as being divided into three areas.
Though it's mostly a philosophic thing right now, it might hopefully be the base for future posts/rants.

