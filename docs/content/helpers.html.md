---
title: Helpers
description: Frontman comes with useful helpers and lets you define your own.
position: 10
---

## Builtin helpers

### `current_tree`

Returns the `SitemapTree` for the current page.

### `current_page`

Returns the `Resource` for the current page.

### `slugify`

Turns a string into a slug suitable for URLs.

```rb
slugify('This is a string')
# returns: 'this-is-a-string'
```

### `format_url`

Returns _pretty_ URLs:

```rb
format_url('about/index.html')  # returns `/about/`
format_url('/about/')           # returns `/about`
```

### `render_markdown`

Converts a Markdown string to HTML

```rb
render_markdown('# Hello World')
# returns: '<h1>Hello World</h1>'
```

### `render_erb`

Converts a ERB string to HTML, running all Ruby code inside it.
You can pass data to the template as the second parameter.

<!-- vale off -->
<!-- false flag of `hello_to` -->

```rb
render_erb('<%= Hello, + hello_to %>', hello_to: 'world')
# returns 'Hello world'
```

<!-- vale on -->

## Custom helpers

All custom helpers must be in the same directory,
and their filenames must end with `_helper.rb`.

To register a helper directory, use the `register_helper_dir` function
in your `config.rb` file:

```rb
# config.rb
register_helper_dir('helpers')
```

Helpers are global. You can encapsulate them in modules,
if you want to define multiple related helpers in the same file.
Since helper methods are global,
make sure to use unique method names for helpers in your project.

```rb
# helpers/custom_helper.rb
def friendly_helper
  'Hello from your friendly helper'
end
```

After registering your helper directory,
you can use the helper methods in your layout or content files.

<!-- vale off -->

```erb
Our helper says: <%= friendly_helper %>
```
