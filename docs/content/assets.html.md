---
title: Asset pipeline
description: Frontman lets you run external tools to process your assets.
position: 11
---

Frontman doesn't come with pre-built themes.
Instead, you can build your own website with layouts and the asset pipeline.

You can declare asset pipelines in your configuration file `config.rb`:

```rb
add_asset_pipeline(
  name: 'Webpack server',
  command: 'pnpm dev',
  timing: :before,
  mode: :serve,
  delay: 4,
)

add_asset_pipeline(
  name: 'Webpack build',
  command: 'pnpm build',
  timing: :after,
  mode: :build
)
```

| Parameter | Type                           | Description                                                                        |
| --------- | ------------------------------ | ---------------------------------------------------------------------------------- |
| `command` | `String`                       | The command you want to run                                                        |
| `delay`   | `Integer` (seconds)            | Delay before running the next command                                              |
| `mode`    | `:build` \| `:serve` \| `:all` | This lets you declare different pipelines for `frontman serve` or `frontman build` |
| `name`    | `String`                       | A friendly name for this pipeline                                                  |
| `timing`  | `:before` \| `:after`          | When to run the asset pipeline---before or after building the site                 |
