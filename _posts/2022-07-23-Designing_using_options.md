---
layout: blog_post
title: Designing using Options
tags:
- design
- architecture
---
One of my favorite software development activities is designing:
thinking of how to create components so they work together really gets me going.
Today, I wanted to write a bit on the way I consider trade-offs in designs.
In particular, I focus a lot on options.

# What are options?

[Options][option (finance)-wikipedia] are a financial instrument that you can buy, thus giving you the option to do something... or not.
For example, you could buy an option to purchase a commodity, say gold, **at a fixed price**, at some point in the future.
This means that, if the price of gold **goes higher than your fixed price**, you can exercise that option and get savings.
If, on the other hand, price goes down, you can **ignore your option** and simply buy gold at its market price.

What does this have to do with software design? Everything!

# YAGNI

There's a very well known acronym in software development called [YAGNI][yagni-Martin Fowler-bliki] (*Y*ou *A*ren't *G*onna *N*eed *I*t):
it describes the situation where someone designs or implements a piece of software that solves not only the current use case,
but also a more general one;
the intent, then, is to remind the engineer that the more general case might never be needed, in which case they just wasted
(potentially a lot of) time.
This could also be called over-engineering or goldplating.

While YAGNI certainly has a lot applicability, I've found that, in practice, development teams *also* fall into the trap of focusing too much
*on the immediate*, to the point where the system devolves into a Big Ball of Mud (a process called
[Architecture by Implication][architecture by implication-Mark Richards-youtube]).

# Designing options

When approaching the design of a system feature, after I've identified most of what's needed *right now*,
I'll try to take a few steps **forward** and imagine:

* what are ways in which this could be used in the future, maybe 1, 3 or even 5 years from now?
* if this becomes a resounding success, what would need to change so it adapts to things like:
  * a user base orders of magnitude larger
  * becoming too large to be maintained by a single team

Being an engineer, I have an easier time with the technical parts of this but sometimes struggle
with the business parts, so I might ask for help from someone who is more product minded.

After collecting a few of these possibilities, I then try to answer the question:
"What should I do (or avoid doing) **now** to ensure that these remain viable?"
This has a very much non-binary answer because, in many cases, keeping options open
requires you to *do something*, which also has a cost: the trick is in keeping
that cost low.

You also have to factor in the time you spend on this as a cost;
however, in my experience, this is a relatively quick exercise and yet yields quite a bit of insight.
Since it requires balance, doing it in a group (by timeboxing it into a meeting) helps.

# An example

An application I've worked on required that, when a user makes a purchase, they receive an email
confirmation.

Given the system capabilities at the time, this would've been fairly easy to implement by making
a direct call:

```java
void doCheckout(Order order) {
    order.markConfirmed();
    email.send(order.client().email(), Templates.orderConfirmation(order));
}
```

However, when I considered the future evolution of this, several questions arose:
1. what if we need to send emails to more than one person?
For example, we might also need to notify the seller or you might be able to order
from multiple sellers, which means they all need to be notified;
2. what if, instead of email, we want to send a text message?
Or a push notification to their phone?
3. what if there are other applications that can send email and we need
to keep the styles consistent?
Or maybe the email logic is just so complex that we want a whole team for it?

What I noticed about these is that all of these **potential** use cases are 
about "how do we react to a certain event happening?"
This strongly suggested that we would benefit a lot from introducing a system
for publishing and subscribing to events;
in this case, we could publish a "order confirmed" event and another component
would receive it and send email.

This is usually done using something like [RabbitMQ][rabbitmq-website] or [Kafka][kafka-website],
especially if you want to have different teams working on each component as separate applications
or allow the system components to scale out.
The cost of running these, or even a cloud provider service like [Google Cloud Pub/Sub][gcloud pubsub-website]
or [AWS Simple Notification Service (SNS)][aws sns-website] is non-negligible though,
and the time cost of operating them would place a big burden on the (at the time) team of three.

The solution, then, was to simply introduce [Publish-Subscribe Channels][pubsub channel-eip site]
that allowed us to write something like:

```java
void doCheckout(Order order) {
    order.markConfirmed();
    channel.publish(new OrderConfirmed(order));
}

@OnEvent(OrderConfirmed.class)
void sendClientEmail(OrderConfirmed order) {
    email.send(order.client().email(), Templates.orderConfirmation(order));
}
```

We did this using [Spring Integration][spring integration-website]
which has an in-process implementation of a Publish-Subscribe Channel,
so we didn't need any immediate changes to our ops infrastructure;
however, because it also has implementations for most popular messaging
systems, we can almost trivially switch to them later.

To summarize: for the low cost of introducing an abstraction
and leveraging an off-the-shelf library that implements it,
the team was able to solve the immediate business problem while
retaining the option of evolving the system.

In fact, we eventually reused the Publish-Subscribe Channel abstraction
for many subsequent features of the application;
had we not "bought" this option so early, we would have had to rewrite
parts of the system later to switch from direct calls to event-driven.

# Conclusion

I've tried to explain how I think about software design in terms of options.
Given my fondness of technical challenges, I tend to get carried away when desiging things
and think too far ahead into the future.

I find that designing in terms of options helps me to balance between
finding the smallest thing that could work (the [MVP][minimum viable product-wikipedia])
without sacrificing the future evolution of the system, while giving me an outlet
for my creativity.

Let me know if you think this is helpful!

[option (finance)-wikipedia]: https://en.wikipedia.org/wiki/Option_(finance)
[architecture by implication-Mark Richards-youtube]: https://www.youtube.com/watch?v=2PnY_Fh3Us8
[yagni-Martin Fowler-bliki]: https://www.martinfowler.com/bliki/Yagni.html
[minimum viable product-wikipedia]: https://en.wikipedia.org/wiki/Minimum_viable_product
[rabbitmq-website]: https://www.rabbitmq.com/
[kafka-website]: https://kafka.apache.org/
[gcloud pubsub-website]: https://cloud.google.com/pubsub/
[aws sns-website]: https://aws.amazon.com/sns/?c=ai&sec=srvm&whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc
[pubsub channel-eip site]: https://www.enterpriseintegrationpatterns.com/patterns/messaging/PublishSubscribeChannel.html
[spring integration-website]: https://spring.io/projects/spring-integration
