---
title: Configuration
description: Adjust your Frontman project to your needs.
position: 2
---

Frontman comes with sensible defaults but lets you structure
your projects the way you want.
It looks for the configuration in the `config.rb` file.

## Change configuration settings

To change your Frontman configuration, use the `Frontman::Config.set` function:

```rb
# config.rb
Frontman::Config.set(:layout_dir, 'layouts')
```

To get a configuration value, use `Frontman::Config.get`.

## Directories

You can change the following directories with `Frontman::Config.set`.

| Setting        | Default          | Description                                          |
| -------------- | ---------------- | ---------------------------------------------------- |
| `:build_dir`   | `build`          | Where Frontman stores the output of `frontman build` |
| `:content_dir` | `source`         | Where Frontman looks for content files               |
| `:layouts_dir` | `views/layouts`  | Where Frontman should look for layout files          |
| `:partial_dir` | `views/partials` | Where Frontman looks for partials                    |

## Multiple configuration files

To include other configuration files in your `config.rb` file,
use the `import_config` helper:

```rb
import_config 'config/sitemap_setup'
import_config 'config/configuration_setup'
```
