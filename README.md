# Jekyll PWA Plugin [![Gem Version](https://badge.fury.io/rb/jekyll-pwa-plugin.png)](http://badge.fury.io/rb/jekyll-pwa-plugin)

> PWA support for Jekyll

This plugin provides PWA support for Jekyll. Generate a service worker and provides precache with Google Workbox.

## Installation

This plugin is available as a [RubyGem][ruby-gem].

Add this line to your application's `Gemfile`:

```
gem 'jekyll-pwa-plugin'
```

And then execute the `bundle` command to install the gem.

Alternatively, you can also manually install the gem using the following command:

```
$ gem install jekyll-pwa-plugin
```

After the plugin has been installed successfully, add the following lines to your `_config.yml` in order to tell Jekyll to use the plugin:

```
plugins:
- jekyll-pwa-plugin
```

## Getting Started

Add the following configuration block to Jekyll's `_config.yml`:
```yaml
pwa:
  sw_filename: service-worker.js # Required
  cache_name: my-cache # Optional
  precache_channel_name: sw-precache # Optional
  precache_recent_posts_num: 5 # Optional
  precache_glob_directory: / # Optional
  precache_glob_patterns: # Optional
    - "{js,css,fonts}/**/*.{js,css,eot,svg,ttf,woff}"
    - index.html
  precache_glob_ignores: # Optional
    - sw-register.js
    - "fonts/**/*"
  runtime_cache: # Optional
    - route: /^api\/getdata/
      strategy: networkFirst
    - route: "'/api/pic'"
      strategy: cacheFirst
```

Parameter                 | Description
----------                | ------------
sw_filename               | Filename of service worker.
cache_name                | Name of cache.
precache_channel_name     | Name of broadcast channel which listens to update event. When precached resouces get changed, Workbox will broadcast an update event through a channel in this name. You can refer to this [example](https://workbox-samples.glitch.me/examples/workbox-sw/).
precache_glob_directory   | Directory of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_glob_patterns    | Patterns of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_glob_ignores     | Ignores of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_recent_posts_num | Number of recent posts to precache.
runtime_cache             | Runtime cache. Register a route and handle matched request with a strategy such as networkFirst, cacheFirst etc. You can refer to this [document](https://developers.google.com/web/tools/workbox/reference-docs/latest/module-workbox-sw.Router) for more information.

We handle precache and runtime cache with the help of Google Workbox v2.1.1 in service worker.

# Contribute

Fork this repository, make your changes and then issue a pull request. If you find bugs or have new ideas that you do not want to implement yourself, file a bug report.

# Copyright

Copyright (c) 2017 Pan Yuqi.

License: MIT

[ruby-gem]: https://rubygems.org/gems/jekyll-pwa-plugin
