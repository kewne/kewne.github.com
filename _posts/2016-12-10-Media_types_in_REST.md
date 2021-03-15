---
layout: blog_post
title: The role of Media Types in REST
tags:
- REST
---
REST (**Re**presentational **S**tate **T**ransfer) is an architectural style
that I've grown very interested in over the years and try to use when
developing webservices.
What I like about REST is that, having been "reverse-engineered" from the
Web architecture, it provides a guide on how to develop webs of services
in an organic (meaning somewhat unplanned and low-friction) manner,
as opposed to trying to design and control a large scale system's evolution.

A central concept of REST is that of media type, which is the property of a
resource that defines its shape and how it should be interpreted.
HTML and PDF resources have their own media type, which allows browsers and
PDF readers, respectively, to interact with these resources.

For a service implementation to be truly RESTful, it also requires usage of HATEOAS
(Hypermedia as the Engine of Application State) which, but for a few
exceptions, forces most resources to be representable in a
hypermedia-enabled media type.

However, one of the key things about media types is that, as I just mentioned, that
it defines not only the shape of a resource but also **how it should be 
interpreted**.
This has the very important consequence that the simple usage of common
media types (like HAL or JSON-LD), even if they do support hypermedia, might not
be enough.

Why *might*?
Because the semantics might be missing.

# Media types as semantics

Consider the following response to a `GET` for the
entry resource of a webservice for handling orders:

`Content-Type: application/hal+json`
{% highlight json %}
{
    "version": 1.0,
    "name": "Order API",
    "_links": {
        "search": { "href": "http://order-api/_search" },
        "http://order-api/create": { "href": "http://order-api/" },
        "metrics": { "href": "http://order-api/_metrics" }
    }
}
{% endhighlight %}

What does this tell us? Well, the HAL ([Hypertext Application Language](http://stateless.co/hal_specification.html))
specification, which defines the `application/hal+json` media type says that the response
is valid JSON, so that defines shape.

What about the links defined in the `_links` attribute?
The spec also tells us that this attribute defines links that can
be used to navigate the API and have the semantics defined by IANA.

The first, `search`, is definitely in the IANA link relations registry
and defines a link to a resource that allows searching of the current
context (which, in this context, is probably searching for orders).

The second, however, is not in the IANA registry.
Fortunately, the Link specification (referenced by the HAL spec)
describes this as an extension relation, so we can hit
`http://order-api/create` to read up on the semantics and
extend our client to support it.

The third is even trickier: it isn't an extension link
but isn't defined in the IANA registry either.
In this case, a custom media type specification would be required to
describe the semantics of the link.
We should then define a `application/vnd.my-company.order+json` or
similarly named media type that is an extension of HAL but defines
the `metrics` link relation type.

# Conclusion

Media types are usually thought of as describing only the shape of
resources.
In this post I've described how media types also describe semantics
and how custom media types can be used to extend the semantics
of existing media types.
