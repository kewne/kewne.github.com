---
layout: blog_post
title: Thoughts on REST style APIs
tags:
- REST
---
I've recently had the opportunity to design a RESTful API at work;
while this isn't the first time I've done it, it's the first time I'm
in a position to seriously influence the design and see how some 
of my design ideas work out in the real world.

While, overall, I think they are working out, I've also started to
hit some issues that lead me to the realization that the REST style
has many limitations when applied to APIs.

<aside>
By APIs, I specifically mean HTTP based APIs,
the type that are usually consumed by either a Javascript application
running in a browser or a backend application.
</aside>

The issue essentially boils down to the fact that it's impossible for
heuristic based clients (like the aforementioned applications) to avoid coupling
to the specifics of the API, thus making it almost impossible to build truly generic clients,
which in turn prevents the architectural style from achieving its goals.

# The golden standard

When defending the REST architectural style, I usually reach for the domination of the
Internet as we know it as the prime example;
the almost complete adoption by browsers of HTTP, HTML and other standards,
means that users can use these browsers to consume every website in existance
in a way that "just works".
This is the ideal that REST strives to achieve: a distributed but ubiquitous and performant
system.

## Why it doesn't work for APIs

Despite their similarities, APIs and websites are different beasts *because their consumers are of significantly different natures*:
while websites are tipically consumed by highly autonomous neural networks (i.e. humans),
APIs are typically consumed by heuristic based applications which lack the ability to understand
the semantics of the content they access and make decisions according to it.

In other words, while humans can easily navigate the Internet with little to no training,
even in websites they've never been to before,
it's almost impossible to create an application that does the same.

For example, when displaying the following in a web page:
```html
<form action="" method="post">
    <h1>Send message</h1>
    <label>Message:
        <input type="text" name="message"></label>
    <input type="submit" >
</form>
```

The browser generates the below (which intentionally doesn't work):
<div class="html-example">
<form action="" method="get">
    <h1>Send message</h1>
    <label>Message:
        <input type="text" name="message"></label>
    <input type="submit" >
</form>
</div>

Any person can look at the above and figure out that they can type a message
and send it.

A computer? Not so much!

You can convert the above into machine-friendlier JSON
(I'm drawing inspiration from HAL-FORMS here):
```json
{
  "_links": {
    "self": {
        "href": "https://example.com",
    }
  },
  "_templates": {
      "default": {
          "method": "POST",
          "properties": [
              {
                  "name": "message",
                  "required": true
              }
          ]
      }
  }
}
```

It is at this point that one of two problems will occur.

### Backend applications

Automated (i.e. backend) applications
do not generally have an autonomous agent commanding it;
instead, the agent navigates the API using preset rules.

This means that, even if the agent understands what a relationship
(a hyperlink) is, it can only follow those links that it's hardcoded
to understand.

Consider the following (HAL based) example for an API response:
```json
{
    "name": "John Doe",
    "age": 22,
    "_links": {
        "self": { "href": "https://example.com/john" },
        "friend-list": { "href": "https://example.com/john/friends" },
        "best-frient": { "href": "https://example.com/john/friends/jane" },
    }
}
```

For a machine, the only way to differentiate between the `friend-list` relationship
and `best-friend` is if these are hardcoded into the program, so it has
very specific expectations of when these appear and how they're used.

### Frontend applications

Another common use case for consuming REST APIs is in Front-End applications,
i.e. applications that read data, display it to the user,
as well as reading data from the user and sending it to the API.

Often, what these applications will do is translate JSON
into user friendly HTML (similar to my initial example above);
the fact that these delegate many choices to the (autonomous) user
means that they, unlike the backend applications just discussed,
don't need to understand the relationships but can delegate that
understanding to the user.

In practice, however, the User Experience of generic
interfaces is pretty low;
while the application wouldn't need to understand 
what the hyperlinks mean, it would have to display them
as links undistinguishable from each other:

<div class="html-example">
<ul>
    <li><a href="https://example.com/john">self</a></li>
    <li><a href="https://example.com/john/friends">friend-list</a></li>
    <li><a href="https://example.com/john/friends/jane">best-friend</a></li>
</ul>
</div>

Additionally, imagine that you're trying to display a
balance (sum of revenues and expenses) for a month;
you might want to display positive values in green
and negative ones in red:

<div class="html-example">
    <table>
        <head>
            <tr>
                <th>Month</th>
                <th>Balance</th>
            </tr>
        </head>
        <tbody>
            <tr>
                <td>November</td>
                <td style="text-align: end; color: green">10€</td>
            </tr>
            <tr>
                <td>December</td>
                <td style="text-align: end; color: red">-10€</td>
            </tr>
        </tbody>
    </table>
</div>

Your usual API response would look something like (other months redacted):
```json
{
    "balances": [
        ...,
        10,
        -10
    ]
}
```

To format the values like this, however, the frontend applications needs to
have the knowledge that positive values are good (i.e. green)
and that negative ones are bad (i.e. red) **built-in by the programmer**!

# Useful still?

So, does the fact that REST has limitations
on what can be achieved when applied to APIs, mean that we should stop using it?

I don't believe so.

In fact, I still believe it should be the default for *most* use cases.

## The rising tide lifts all boats

Consider an alternative API design style that uses gRPC (i.e. Protocol Buffers over HTTP):
what would it use for the `Content-Type` header?

Turns out it doesn't use any specific value (and could even use `application/octet-stream`):
the reasoning is that, by itself, knowing a given message is Protobuf is pretty much useless;
you'd need the message specification to interpret it, a specification which is
almost sure to be unique for any pair of APIs you could find.

On the other hand, media types that offer hypermedia capabilities (e.g. HAL, Hydra, JSON-LD)
have a specific format, that clients may use to navigate **all** APIs that use those formats.

At this point, you might be inclined to ask <q>but I don't want to use **all** APIs in the world,
I just need to use **this** specific API!</q>.
The thing is, if just one person builds a high-level API client that understands HAL,
you can use it on any API that produces HAL and only have to work on the parts that are specific
to that specific API.

As an example, here's how you'd use RPC calls for sending a message:

```js
const friendList = api.getListOfFriends();
const friendInbox = api.getInboxForUser(friendList[0].id);
api.sendMessageTo(friendInbox.id, {message: "Hi there"}));
```

By contrast, here's how it'd look using a hypermedia format:
```js
api.getRel("friendList")
  .getRel("item") // implicitly gets the first item of a plural relationship
  .getRel("inbox")
  .post({message: "Hi there"});
```

Another example, this time for buying something, RPC style:
```js
const catalogPage = api.getFirstCatalogPage()
  .getNextPage()
  .getNextPage();
const product = catalogPage.products[5];
const order = api.placeOrder({payment_method: "credit_card"});
// waits for user to pay
api.confirmPayment(order.id);
```

And this time with a hypermedia format:
```js
const order = api.getRel("catalog")
  .getRel("next")
  .getRel("next")
  .getRelAtIndex("item", 5)
  .getRel("checkout")
  .post({payment_method: "credit_card"});
// waits for user to pay
order.getRel("paymentStatus")
  .put({status: "CONFIRMED"});
```

To me, what's apparent about these samples is how similar the hypermedia
ones are (because most operations are traversing relationships), while
the RPC ones are quite different and, additionally, rely on the structure
of the data to navigate (e.g. when using `friendList[0].id` and `catalogPage.products[5]`).

While this may seem like a minor difference, implementing the client for the
RPC style API would involve either hand-writing (with expensive engineering cost)
or auto-generating it from a spec (assuming one exists, in which case you still have
to set up the toolchain for it);
by contrast, the hypermedia API requires only a dependency on a library that uses the
correct media type.
