---
title: Hub Resource
---
While many resources in an API belong to the same domain,
they are often different enough that there is no obvious relation between them.
Additionally, clients might want to access a resource without first having to access other related resources
(e.g. listing a user's order history doesn't require reading the user's data beforehand).

> # Given that an API exposes many different resources without an obvious semantic connection, how can it generate links for clients to navigate?
> Introduce a Hub resource that only links to other resources

A [Root Resource][root-resource-pattern] is often implemented as a Hub Resource.

# Sequence Diagram

{% plantuml %}
!theme mars
skinparam NoteFontName Courier

actor Client as client
boundary API as api

client -> api++: GET /
return 200 OK
note left
{
  "_links": {
    "user": {
      "href": "https://example.com/users/123456"
    },
    "order-history": {
      "href": "https://example.com/orders?user_id=123456"
    }
  }
}
endnote

client -> api++: GET *order-history
return 200 OK
{% endplantuml %}

# Properties

## Strengths

## Weaknesses


[root-resource-pattern]: root_resource
