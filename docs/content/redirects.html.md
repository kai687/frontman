---
title: Redirects
description: Add redirects for pages that you rename or delete.
position: 6
---

To add a redirect, use the `add_redirect` function in your `config.rb` file:

```rb
# config.rb

add_redirect('/from-url/', '/to-url/')
```

This creates a new HTML file `from-url/index.html` with
[meta refresh](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/meta#http-equiv)
tags.

> [!TIP]
> Configure your server or hosting platform to return [301 headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/301) as well.
