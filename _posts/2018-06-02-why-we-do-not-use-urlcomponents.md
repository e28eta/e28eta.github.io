---
layout: single
title: Why we do not use URLComponents
date: 2018-06-02 22:07:29
tags: [iOS, NSURLComponents, URLComponents, NSURLQueryItem, URLQueryItem, application/x-www-form-urlencoded]
published: true
---

The short version? Because it doesn't do its job escaping content.

# Web URLs

Web URLs can be broken into a bunch of components. I'll borrow a diagram from [RFC 3986](https://tools.ietf.org/html/rfc3986#section-3):

      URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]

         foo://example.com:8042/over/there?name=ferret#nose
         \_/   \______________/\_________/ \_________/ \__/
          |           |            |            |        |
       scheme     authority       path        query   fragment
          |   _____________________|__
         / \ /                        \
         urn:example:animal:ferret:nose


Constructing and parsing valid URLs is non-trivial, because it needs to be properly formatted *and* escaped, and the rules can differ by the component.

# Percent Encoding

*Any* time a data format has characters that mean something special, it needs some way to escape those characters so they can be used in the content. URLs use percent encoding:  `%` plus the two digit hex code of that byte. For example, the space character is `0x20` in ASCII/UTF-8, and is `%20` when percent encoded.

It's worth noting at this point that percent encoding *is not* restricted to special characters. You could percent encode *every* content character if you were so inclined. From [RFC 1738](https://tools.ietf.org/html/rfc1738#section-2.2) (1994):

> Thus, only alphanumerics, the special characters `$-_.+!*'(),`, and reserved characters used for their reserved purposes may be used unencoded within a URL.

> On the other hand, characters that are not required to be encoded (including alphanumerics) may be encoded within the scheme-specific part of a URL, as long as they are not being used for a reserved purpose.

Although if you do, [RFC 3986 section 2.3](https://tools.ietf.org/html/rfc3986#section-2.3) warns that you might not receive the resource you expect:

> However, URI comparison implementations do not always perform normalization prior to comparison (see Section 6). For consistency, percent-encoded octets in the ranges of `ALPHA` (`%41-%5A` and `%61-%7A`), `DIGIT` (`%30-%39`), hyphen (`%2D`), period (`%2E`), underscore (`%5F`), or tilde (`%7E`) should not be created by URI producers and, when found in a URI, should be decoded to their corresponding unreserved characters by URI normalizers.


# `URLComponents` (aka `NSURLComponents`)

On iOS + macOS, Foundation provides [`URLComponents`](https://developer.apple.com/documentation/foundation/urlcomponents/) (in Swift, [`NSURLComponents`](https://developer.apple.com/documentation/foundation/nsurlcomponents/) in Obj-C), which "parses and constructs URLs according to RFC 3986". It has properties for the components of a URL: `schema`, `host`, `path`, `query`/`queryItems`, etc.

It can also handles percent encoding/decoding, with corresponding properties for the percent encoded components of a url: `percentEncodedHost`, `percentEncodedPath`, `percentEncodedQuery`, etc.

Finally, it has a `url` property, that creates/returns a `URL` object that can, for example, be passed to `URLSession`.

Other blog posts about `URLComponents` are using it to build URLs, and that's what our app was doing too. In theory, it's great having a typed interface to build a URL, especially with the query.


# The Query

For `http`/`https`, the `query` is a list of names and values (`name=value` or just `name` to omit the value). The query starts with `?`, each entry is separated by `&`, and it ends when the fragment starts (`#`).

A web service can use the query however it wants, but it's often used for optional or varying parameters for a request, especially for RESTful APIs. For example, a web service that returns a list of results might use `limit` and `offset` query parameters instead of returning *every* result. Some other uses might be search terms, filters, tags, etc.

It's especially important to get encoding/escaping correct when dealing with user input. In my experience, user-entered data sent to a web server usually either ends up in the query or in the body of the request (instead of: other components of the URL, HTTP headers).

# `URLQueryItem` (aka `NSURLQueryItem`)

`URLComponents` has a property `queryItems: [URLQueryItem]`. A `URLQueryItem` represents:

> A single name-value pair from the query portion of a URL.

This is great! `URLComponents` allows us to construct a list of query items from some parameters. We don't have to worry about percent encoding, and it'll spit out the URL for the request.

# Pitfall #1: The `+` sign

Hopefully you were reading the documentation for `NSURLComponents.queryItems`, and not `URLComponents.queryItems` (yep, they're different! [rdar://40751862](http://www.openradar.me/40751862)), because then you'll be aware of the first pitfall waiting for you: the `+` sign.

> RFC 3986 specifies which characters must be percent-encoded in the query component of a URL, but not how those characters should be interpreted. The use of delimited key-value pairs is a common convention, but isn't standardized by a specification. Therefore, you may encounter interoperability problems with other implementations that follow this convention.

> One notable example of potential interoperability problems is how the plus sign (+) character is handled:

> According to RFC 3986, the plus sign is a valid character within a query, and doesn't need to be percent-encoded. However, according to the W3C recommendations for URI addressing, the plus sign is reserved as shorthand notation for a space within a query string (for example, ?greeting=hello+world).

> If a URL query component contains a date formatted according to RFC 3339 with a plus sign in the timezone offset (for example, 2013-12-31T14:00:00+00:00), interpreting the plus sign as a space results in an invalid time format. RFC 3339 specifies how dates should be formatted, but doesn't advise whether the plus sign must be percent-encoded in a URL. Depending on the implementation receiving this URL, you may need to preemptively percent-encode the plus sign character.

> As an alternative, consider encoding complex and/or potentially problematic data in a more robust data-interchange format, such as JSON or XML.

"Hey, our behavior is technically correct, but yeah, it doesn't work in practice for everyone." Here's the recommended workaround from openradar.me and [stack overflow](https://stackoverflow.com/a/37314144):

```swift
components.queryItems = ...
components.percentEncodedQuery = components.percentEncodedQuery
        // manually encode + into percent encoding
        .replacingOccurrences(of: "+", with: "%2B")
        // optional, probably unnecessary: convert percent-encoded spaces into +
        .replacingOccurrences(of: "%20", with: "+")
```

If you need to convert `%20` into `+`, the order *matters* and you better only manually encode once, right before reading `components.url`.

# Surprise! Query items separated by `;`

At least it was a surprise to me. The [W3C HTML 4.01 spec](https://www.w3.org/TR/1999/REC-html401-19991224/appendix/notes.html#h-B.2.2) (from 1999) recommends that web servers *also* allow `;` to separate query items, in addition to `&`:

> We recommend that HTTP server implementors, and in particular, CGI implementors support the use of `";"` in place of `"&"` to save authors the trouble of escaping `"&"` characters

In retrospect, it's eminently practical. Since `;` doesn't need to be escaped when used in html (unlike `&`, which needs to be `&amp;` or `&#38;`), it's safer when the content is under-escaped. It *also* works with *double-escaped* `&` characters: `n1=v1&amp;n2=v2`. Splitting on *both* `&` and `;` would yield a garbage `amp` query item, but preserves `n1` and `n2`.

Knowing that it exists, it's possible to find content about it. Like a [2010 post on stack overflow](https://stackoverflow.com/q/3481664) asking about support for `;`, with the top comment from 2016 pointing out it's *not* allowed (anymore) in the HTML 5 standard. Or Rack, which prior to 1.6.0 allowed `;` to separate parameters. That was [fixed](https://github.com/rack/rack/commit/71c69113f269f04207157bee6c197b5675f3df61), and three weeks after 1.6.0 shipped, [a bug was filed](https://github.com/rack/rack/issues/782) asking for it back (that bug is still open 3.5 yrs later). I haven't looked further, but I'm sure there is varying support based on the age & ubiquity of a project.

# The last straw: the semicolon `;`

As I'm sure you've guessed, `URLQueryItem` and `URLComponents` *also* fail to percent encode `;` characters. In a brief search, I didn't find this discussed anywhere online.

For me, the *primary* reason to use a URL construction class is to delegate underlying details like this. It has failed us twice, and that's enough. It's eminently possible that we could simply add *another* `.replacingOccurrences(of: ";", with: "%3B")`, and never run into another problem.

*However*, the alternative ended up being simpler, and does not subject us to the whims of Foundation engineers and their strict adherance to RFC 3986. I'm pretty disappointed in `URLComponents`, because I think it fails Postel's Law:

> be conservative in what you do, be liberal in what you accept

IMO, the conservative approach would be to percent encode *any* content characters that had the potential to be misinterpreted, because a percent encoded character is *unambiguous*. Instead, they closed [rdar://24076063](http://www.openradar.me/24076063) as behaves correctly and added a note to (some of) the documentation.

# Encoding/escaping matters

SQL Injection & XSS. What do they have in common? User input is not properly escaped, and so it's treated as instructions instead of content.

I *don't* think a failure to escape `;` from a user is going to lead to the same level of ubiquituous security vulnerabilities, but it's in the same category of bug. It's not just "oh, the user can create bad requests" - it's "the user can add totally unexpected parameters to my request".

For example, given this Sinatra 1.4.8 + Rack 1.5.5 web app that echos back the parameters:

```ruby
require 'sinatra'

get '/' do
    "#{params.to_s}"
end
```

If a user types in `foo;bar` into a search field, with `URLComponents` the `;` is not escaped:

```ruby
"GET /?query=foo;bar" -> {"query"=>"foo", "bar"=>nil}
```

If it *did* escape the `;`, it would produce:

```ruby
"GET /?query=foo%3Bbar" -> {"query"=>"foo;bar"}
```

In the first example, the user doesn't see the right query results *and* there's a whole new parameter: `bar` (which may or may not mean anything to the web server).


# Our Alternative

I created a custom struct, `EncodedQueryItem`, that has the same `name`/`value` properties, but transforms them using `addingPercentEncoding(withAllowedCharacters: .alphanumerics)`.

Then, given `[EncodedQueryItem]`, we convert the query items into `name[=value]` strings, join them with `&`, and append it to our `URL`, preceeded with `?` or `&` based on whether the URL's `query` was empty or not. (This would be more complicated if we used the `fragment`, but we don't)

We percent encode everything that isn't `.alphanumeric` for simplicity. I may end up modifying the `CharacterSet` and adding hyphen, period, underscore, and tilde, to better conform to the recommendation from [RFC 3986 section 2.3](https://tools.ietf.org/html/rfc3986#section-2.3), but for now this is working.

# `application/x-www-form-urlencoded`

The *same* format, a list of percent encoded `name[=value]` strings separated by `&` (*or* possibly `;`), is used for `application/x-www-form-urlencoded` content `POST`ed in the body of a request. This content type is common for HTML forms, but it's also a legitimate format for web services.

Creating a `URLComponents`, populating the `queryItems` and then putting the `percentEncodedQuery` into the `POST` body seems like a reasonable method for generating `application/x-www-form-urlencoded` content. And it would be, if `URLComponents` properly escaped your content.

Instead, I recommend rolling your own. Share the same code that's used to generate the query items in the url. `POST` requests are *more* likely to contain free-form user-entered data, and often have more parameters, although I don't think that should make a difference in the importance of avoiding `URLComponents`.
