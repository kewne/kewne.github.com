---
layout: blog_post
title: Reducing tests based on method call verification
tags:
- testing
---
Out of today's programming practices, testing is probably one of the few
that is widely accepted.
However, in my opinion, test code tends to be written with less care and,
as a consequence, to rot much more quickly than application code.
Something I see much more commonly than I would like to is method call verification in tests.
Using Mockito in Java it looks like this:

{% highlight java %}
public void shouldPlaceOrder() {
    OrderRepository repo = mock(OrderRepository.class);
    OrderService service = new DefaultOrderService(repo);
    List<Order> orders = new ArrayList<>();
    orders.add(new Order("book"));
    orders.add(new Order("movie"));
    service.placeOrders(orders);
    verify(repo, times(2))
        .save(any(Order.class));
}
{% endhighlight %}

The problem with this is that, despite working, it breaks very easily, because it's leaking the implementation of `OrderService`: without even looking at the class' implementation, we know that it calls the `save` method on the `OrderRepository` twice.
This test will break every single time the method calls change, which, besides the obvious extra work involved, makes changes more risky since you can't just change the implementation and verify it against the same test as the previous version.

Another thing that bugs me is that, even when you take the time to capture arguments and perform assertions on them, you're still relying on that method being called, instead of relying on the underlying behavior.
The semantics are completely wrong: *something should have changed when that method was called* and that's the assertion that should be made.
Taking a look at the class' documentation (even if it's just tribal knowledge), you'd probably find something similar to:

{% highlight java %}
public class DefaultOrderService implements OrderService {

  private final OrderRepository;

  /**
  *  Places orders, and saves all the successfully
  *  placed orders using the underlying OrderRepository.
  */
  void placeOrders(Collection<Order> orders) {
    // here be logic
  }

}
{% endhighlight %}

In this example, the expected behavior seems to be that the orders are saved on a datastore accessed by `OrderRepository`, so I would instead try to write the test like this:

{% highlight java %}
public void shouldPlaceOrder() {
    OrderRepository repo = new SimpleOrderRepository();
    OrderService service = new DefaultOrderService(repo);
    List<Order> orders = new ArrayList<>();
    orders.add(new Order("book"));
    orders.add(new Order("movie"));
    service.placeOrders(orders);
    assertNotNull(repo.getByName("book"));
    assertNotNull(repo.getByName("movie"));
}
{% endhighlight %}

This involves a bit more work to code the `SimpleOrderRepository`, which is why I suspect it doesn't get done more often, but the result is much more resilient to change.
Depending on the kind of infrastructure you're using, you could even use the actual application implementation (and tradeoff precision for coverage).

The reason you're able to do this switching is because now the test relies only on the "interface" of the class under test and the `OrderRepository` interface.

Things get even more interesting when you change the `OrderService` interface:

{% highlight java %}
public interface OrderService {
  /**
  *  Attempts to place orders and returns the results.
  */
  Collection<OrderPlacementResult> placeOrders(Collection<Order> orders);

  public static interface OrderPlacementResult {
    Order order();
    // An enum describing possible outcomes
    Status status();
  }

}
{% endhighlight %}

By adding this return value, we can write tests _against the interface_:


{% highlight java %}
public void testOrderPlacedOk() {
  OrderService uut = getOrderService();
  Collection<Order> os = getBunchOfOrders();
  Collection<OrderPlacementResult> oprs = uut.placeOrders(os);
  for (OrderPlacementResult r : oprs) {
    assertTrue(os.contains(r.order()));
    assertEquals(Status.Success, r.status());
  }
}

public void testOrderPlacedNoStock() {
  OrderService uut = getOrderServiceNoStock();
  Order o = getOrder();
  Collection<OrderPlacementResult> oprs = uut.placeOrders(singleton(o));
  assertEquals(1, oprs.size());
  OrderPlacementResult theOpr = oprs.iterator().next();
  assertEquals(o, theOpr.order());    
  assertEquals(NoStock, theOpr.status());    
}

public void testOrderPlacedNoFunds() {
  OrderService uut = getOrderServiceNoFunds();
  Order o = getOrder();
  Collection<OrderPlacementResult> oprs = uut.placeOrders(singleton(o));
  assertEquals(1, oprs.size());
  OrderPlacementResult theOpr = oprs.iterator().next();
  assertEquals(o, theOpr.order());    
  assertEquals(Status.NoStock, theOpr.status());   
}
{% endhighlight %}

I've ommitted the setup logic because that's necessarily implementation-dependent but `OrderService` can be implemented by using webservice calls, calling a datastore or using in-memory structures and the essential test case assertions are the same.

Let me say it again: *except for some basic setup, the above tests should always pass, regardless of the implementation*.
For a little upfront design work, we've made these tests resilient to a whole class of changes.

Also note that this isn't a case of designing for currently unnecessary features: you don't need to write the whole simple implementation at once, so the work involved is comparable to writing the mocking logic, with much higher reusability, and it leaves you open for tuning the implementation (like doing operations in batch or asyncronously).

In this post, I've tried to outline the reasons why method call verification produces brittle tests, as well as propose some alternatives that are similar in terms of implementation cost but produce tests that are more robust to change.
Whether you agree or not, feel free to comment.
In particular, do you think there are situations where method call verification is useful?
