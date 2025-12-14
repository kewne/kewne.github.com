---
layout: blog_post
title: "Why I don't like it when API clients build URLs"
tags:
- API
- REST
- design
---
While writing the "Strengths and Weaknesses" section for the [Toggle Param Pattern]({% link _patterns/toggle_params.md %}), I found myself trying to explain how having API clients build URLs to make requests is a bad practice.
When I try to argue against this with other engineers, I usually get back a shrug, which I explain with the fact that it's seen as an unavoidable consequence of designing and working with REST APIs.

This is how it usually goes: you document a resource as being available on a [URL that follows a certain template](https://en.wikipedia.org/wiki/URI_Template). An example of this would be `https://example.com/users/{user-id}`, where the `{user-id}` part is replaced with concrete values like `1` or `abcde`.

Why is this problematic?

# Serialization

The first problem is a practical issue of serialization.
While generating JSON or XML using raw strings would immediately raise eyebrows and get called out in review, it's way too common to build URLs in this fashion.
This potentially results in characters [not being correctly encoded](https://en.wikipedia.org/wiki/Percent-encoding), which produces subtle bugs.

# Sourcing the parameters

The next problem is how the parameters are sourced.
Almost all parameters in URL templates fall into two different categories, each with different problems.

## Reference parameters

Reference parameters are parameters that reference other resources in the API, *usually* in the form of IDs.

The problem with these parameters is that using them couples clients to that API's specific way of using the parameters.
Clients *must* understand which particular properties in the API are references.
This makes them API specific, meaning there is no common protocol that can be leveraged to integrate quickly with a new API.

In practice, this forces systems that integrate with 5 different APIs to build 5 different clients, with very little reuse.
This is usually alleviated because API providers either:

* provide an SDK that abstracts away the HTTP interactions;
* publish a specification that can be used by tools to generate the said SDK.
[OpenAPI](https://www.openapis.org/what-is-openapi) is an example of a specification language with this goal.

However, because none of the SDKs are interoperable, clients are still left with the work of gluing together calls between the different APIs

In addition, clients *must* know the URL structure of the API, which makes it impossible for the service to change this structure, even in cases where the changes would be semantically equivalent.
An example of this would be changing a user's friend list from `/users/{user-id}/friends` to `/users{?friends_of}`.

## Form parameters

The second class of parameters is parameters that the client generates itself, either because a user filled them in a UI (hence the name "form") or because the client has a built-in heuristic for generating them.
This class of parameters differs from the previous one because, when a client provides incorrect form parameters, the API *should* produce a response that describes which parts are wrong and why they're so, so that the client may display that information to a user that can correct it.
By contrast, **providing incorrect reference parameters is a programming error** which *should* only show a generic message to the user.

This becomes problematic because, in many cases, reference parameters may also be form parameters when they reference an API resource but are also selected by the user.
What this means is that APIs *must* always respond in a way that allows clients to handle the response as if the invalid parameter was provided by the user.

As a concrete example, let's consider the case where 
{% highlight http %}
{
    "validation_errors": {
        "user_id": [
            "The given user does not exist"
        ]
    }
}
{% endhighlight %}

This mix of concerns means that clients need to handle errors differently depending on context:

* if the invalid parameter is a reference parameter that comes from user input, the client must show an error message to the user;
* if there is a validation error for a reference parameter that doesn't come from user input, the client must raise an error.
