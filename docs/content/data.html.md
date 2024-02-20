---
title: Data files
description: Include global data in your files and generate pages from data.
position: 8
---

Store data in YAML files and reuse it in your project.

## Register data files

To register data files, use the `register_data_dirs` function
in your `config.rb` file:

```rb
# config.rb
register_data_dirs(['data'])
```

You can now access information stored in any YAML file in this directory,
by using the data directory's name as method inside your content or layout files:

```erb
<%= data.<FILE>.<KEY-IN-FILE> %>
```

To use an alias for the data directory, use a hash instead of an array:

```rb
# config.rb
register_data_dirs({
    custom_data_alias: 'path/to/data'
})
```

## Example

Consider the following directory:

```sh
data/
├── people.yml
└── departments/
    ├── sales.yml
    └── engineering.yml
```

Consider the following content of the `people.yml` file:

```yml
- Idris
- Viola
- Naomi
```

After registering your data directory, you can access these names:

```erb
<% data.people.each do |name| %>
 <%= name %>
<% end %>
```

This approach also works with nested directories.
For example, if the `departments/sales.yml` file has the following structure:

```yml
enterprise:
  - Idris
mid-market:
  - Viola
```

You can list all employees by segment:

```erb
<% data.departments.sales.each do |segment, employees| %>
People working on <%= segment %> accounts: <%= employees.join(', ') %>.
<% end %>
```
