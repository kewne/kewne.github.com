---
layout: blog_post
title: Thoughts on Hypermedia
---
One of the services maintained by my team on my current project exposes a RESTish API and a pub-sub mechanism for receiving notifications when a resource is modified.
The service was originally created for a single consuming service, also under my team's responsibility, but is expected to be consumed by new services in the not so distant future.
This has caused some concern for me because, having been developed in parallel with the consuming service by the same team, the service is a poster-child for Conway's Law:

* resources exposed are tailored to the specific needs of the consumer
* documentation is extremely poor *when it exists*
* lots of implicit knowledge of the API structure encoded in the consumer

Since the API will have more consumers in the near future which might not be developed by my team, the last two points could become problematic, so I've been studying several ways in which we can improve the documentation and experience for service consumers.

My first attempt at this was to create nice documentation: there are all kinds of tools for this (like Swagger and Spring REST Docs, for example) and we could just publish the docs to a public place.
However, something that always bothers me when writing documentation is that it gets outdated very quickly and almost always never gets read.
For me, the tools I've mentioned make it hard to strike a balance between making documentation authoring fast and cheap and getting actual value out of that documentation.
Another thing to consider is also that the service works with both regular request-response mechanisms *and* pub-sub and those documentation methods don't work for pub-sub as far as I know.

# Hypermedia is application documentation

For some reason, I eventually found myself going through Roy Fieldings' (aka the REST guy) blog posts and comments.
As you may or may not know, HATEOAS (or Hypermedia As The Engine Of Application State) is a central feature of the REST architectural style which places the burden on a service to "guide" clients through the possible transitions and operations (for those who haven't heard of HATEOAS, think of it as basically adding links to service responses).
As you may learn if you read Roy's blog, this is one of the features that would-be RESTful APIs tend to neglect, but is central in REST's scalability concerns by making clients loosely-coupled to the service.

As an example, imagine you make a request to a car API's entrypoint and get the folowing response:

{% highlight json %}
{
    "version": 1.0,
    "name": "Car API",
    "links": {
        "search": "http://car-api/_search",
        "news": "http://car-api/_news"
    }
}
{% endhighlight %}

As a client receiving this response, you now know that there are at least two services provided by this API, search and news, and where you need to go to consume them.
This allows the client to ignore the API's specific structure and focus on the abstractions, *much in the same way you usually do when visiting a webpage*: 

1. Go to `facebook.com`
2. Click one of your groups
3. Scroll up and down the feed
4. Click on a news link

Notice how the only out-of-band information needed is:

* The site's root is at `facebook.com`
* There is a groups feature with a newsfeed
* The newsfeed contains links to other sources of information

From a documentation standpoint, this limits the explaining to just this out-of-band model, since the rest can be inferred from navigating the API.
To me, this strikes precisely the balance documentation effort/payoff I've been looking for, since it's *self-documentation that looses coupling*.

# Hypermedia supports cross-scheme interactions

However, this only solves the problem for the request/response part of the service interactions.
Supposing we want to notify a user of a news article that's just been published, and assuming the user had subscribed, it would receive a message such as:

{% highlight json %}
{
    "id": 784013,
    "title": "'Self-driving cars a reality in the near future', says Bill",
    "Summary": "Bill, founder of SuperCars Inc., interviewed by JNN."
}
{% endhighlight %}

A client that receives this message would probably want to navigate to the article.
However, the absence of a direct URL means that client would need to have implicit knowledge of how to navigate there, so a better way to structure the message would be this:

{% highlight json %}
{
    "title": "'Self-driving cars a reality in the near future', says Bill",
    "Summary": "Bill, founder of SuperCars Inc., interviewed by JNN.",
    "links" : {
        "article": "http://car-api/_articles/bceahs-ueoh892gd-ueoad9"
    }
}
{% endhighlight %}

At this point, this change should be pretty obvious, but it contains the important lesson that *Hypermedia can work across schemes*.
In this example, a message in a pub-sub protocol turns into an interaction in a request-response one, but the converse could be true:

{% highlight json %}
{
    "version": 1.0,
    "name": "Car API",
    "links": {
        "search": "http://car-api/_search",
        "news": "http://car-api/_news",
        "news-updates": "ws://car-api/_updates"
    }
}
{% endhighlight %}

This tells a client where and how it can subscribe to updates.

What I find interesting about this approach is, besides its ease of use and understanding, how it could influence several other aspects of application design.

## Configuration

Instead of configuring hostnames for several schemes that are actually the same service, configuration could be driven by hypermedia distributed by the service's authority.
This means that configuration such as:

{% highlight json %}
{
    "car-api": {
        "http-root": "http://car-api",
        "ws-root": "ws://car-api"
    }
}
{% endhighlight %}

could become 

{% highlight json %}
{
    "car-api-root": "http://car-api"
}
{% endhighlight %}

and acessing that root URL would return the link to "news-updates" with the WebSockets scheme.

## Authentication/Authorization

Such a way of interacting also makes it obvious that a single credential is enough for a single client, turning

{% highlight json %}
{
    "car-api": {
        "http-user": "my-client-id",
        "ftp-user": "my-ftp-client-id-which-is-usually-the-same"
    }
}
{% endhighlight %}

into

{% highlight json %}
{
    "car-api": {
        "user": "my-client-id"
    }
}
{% endhighlight %}

with the potential added benefit of simplifying authorization management using a central system.

# Conclusion

In this post I've written about some potential uses of Hypermedia.
Hypermedia is almost always forgotten in RESTful APIs and, even then, it's not given much though but could, in my opinion, be used in a way that enables auto-discovery and configuration of services across schemes.
