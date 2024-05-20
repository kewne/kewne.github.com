---
title: Selector Resource
---
A resource has a property that can be changed by the client but must have a value within a specific set.

> # How can an API indicate to clients what the available, correct values for selection are?
> Use a Selector Resource to list the options.

# Sequence Diagram

![Sequence Diagram for the selector resource pattern](selector_resource_sequence/selector_resource.svg)

# Example client code

TBD

# Properties

## Strengths

### Business logic is centralized

Clients don't have to duplicate the business logic for deciding whether an option is possible or not,
thus avoiding inconsistencies.

This centralization avoids [developmental coupling][nygard-coupling-model] between the client and the API.

## Weaknesses

### May require more round trips

When logic that generates the options is implemented in the client,
there is no need to make a request to the Selector Resource, thus saving a round trip in the network.

For example, a "quantity" property can only have values in the set of natural numbers (i.e. non-negative integers).

# Alternatives

# Related patterns

## [Commit resource][commit-resource-pattern]

For Hypermedia based APIs, a Selector Resource will usually link to Commit Resources, one for each selectable item.

When one of those Commit Resources is POST'ed to, the server performs the update of the original resource.

[nygard-coupling-model]: https://youtu.be/69ZsszwycPU
