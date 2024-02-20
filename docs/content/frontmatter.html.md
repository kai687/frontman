---
title: Frontmatter
description: Add metadata and page-specific variables to your pages and layouts with YAML frontmatter.
position: 7
---

Any page or layout can contain YAML frontmatter, delimited by `---` from the main body:

```yaml
---
title: Hello title
languages:
  - English
  - French
---
```

You can access the frontmatter data with the `current_page.data` object:

```erb
I speak the following languages:

<ul>
  <% current_page.data.languages.each do |lang| %>
    <li><%= lang %></li>
  <% end %>
</ul>
```
