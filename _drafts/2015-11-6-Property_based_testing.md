---
layout: blog_post
title: Property based testing
has_code: true
---
Explain property based testing:
Property-based testing is essentially a way of asserting a certain property of a piece of code that holds for a whole category of inputs.
This is opposed to example based testing, which uses the a finite and fixed set of data points.

As an example (no pun intended), this is what an example-based test looks like :
{% highlight java %}
@Test
public void shouldJoinStrings() {
    assertEquals("Cat, Dog, Fish", join({"Cat", "Dog", "Fish"}, ", ");
}
{% endhighlight %}

If you're really professional, you'll try to write tests that catch edge cases for this, like what happens when the array is empty, etc.

On the other hand, the same test, written as a property test, would look something like

{% highlight java %}
@Test
public void shouldJoinStrings(String[] origin, String glue) {
    String capitalized = join(origin, glue);
    int expectedLength = lengthSum(origin) + (origin.length-1)*glue.length();
    assertEquals(expectedLength, capitalized.length());
}
{% endhighlight %}


Let's focus on what's going on: first of all, the inputs have been moved into method parameters, suggesting it is built somewhere else.
But where, exactly?

Well, the details depend on the particular framework you're using but, essentially, it boils down to this: the same test should be valid for a whole range of inputs, so _it could be any value in that range_.
Ideally, you would test for every value (it might be possible in some instances) but, in practice, you generate random data and test with a finite (but large) number of samples.
Sometimes input reduction, which is the narrowing of inputs to identify the simplest cases that produce failures, is used but I haven't because, as far as I know, there's no Java library that implements that.

Coming back to the example above, we can easily see, by looking at both tests, that the property-based one doesn't (because it can't) rely on the concrete form of the input, which is the advantage of property-based tests: _by being executed with sets of inputs unknown beforehand, property-based tests emphasize thinking in terms of property verification_.

In this case, the property being verified is _after joining the String array, the result should have a length equal to the sum of all Strings in the array plus the length of the glue times the number of joined elements minus one_.

We can come up with some other properties too, like:

* _Splitting the result String using the glue as separator should yield the input String_
* _Every input string should be a substring of the result string_
* _The glue string occurs in the result string exactly `n - 1` times, where n is the number of input strings_

# Why property-based tests are _better_

While I'm not advocating using only property-based tests, it is my default technique for writing tests.

## Produces clearer code

As with everything, this depends on discipline, and you can certainly write a property-based mess that is much worse that an example-based one.
However, example-based tests easily become "this String should be equal to this literal" tests which, despite easier "to read", obfuscates the true intention of the test code (and thus the code under test).

## Produces more robust tests


