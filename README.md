# Jekyll PWA Plugin [![Gem Version](https://badge.fury.io/rb/jekyll-pwa-plugin.png)](http://badge.fury.io/rb/jekyll-pwa-plugin)

> PWA support for Jekyll

This plugin provides PWA support for Jekyll. Generate a service worker and provides precache and runtime cache with Google Workbox.

Google Workbox has already developed a series of [tools](https://developers.google.com/web/tools/workbox/). If you use Webpack or Gulp as your build tool, you can easily generate a service worker with these tools. But in my blog, I don't want to use even npm, and I want to precache recent 10 posts so that they are offline available to visitors even though these posts were never opened by visitors before. That's why I try to integrate this function in Jekyll build process.

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
  dest_js_directory: assets/js # Required
  cache_name: my-cache # Optional
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
dest_js_directory         | Directory of JS in `_site`. During the build process, some JS like workbox.js will be copied to this directory so that service worker can import them in runtime.
cache_name                | Name of cache.
precache_glob_directory   | Directory of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_glob_patterns    | Patterns of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_glob_ignores     | Ignores of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_recent_posts_num | Number of recent posts to precache.
runtime_cache             | Runtime cache. Register a route and handle matched request with a strategy such as networkFirst, cacheFirst etc. You can refer to this [document](https://developers.google.com/web/tools/workbox/reference-docs/latest/module-workbox-sw.Router) for more information.

We handle precache and runtime cache with the help of Google Workbox v2.1.1 in service worker.

## Note

### Generate a manifest.json?

This plugin won't generate a [manifest.json](https://developer.mozilla.org/en-US/docs/Web/Manifest). If you want to support this PWA feature, just add one in your root directory and Jekyll will copy it to `_site`.

### When my site updates...

Since the service worker has precached our assets such as `index.html`, JS files and other static files, we should notify user when our site has something changed. When these updates happen, the service worker will go into the `install` stage and request the newest resources, but the user must refresh current page so that these updates can be applied. A normal solution is showing a toast with the following text: `This site has changed, please refresh current page manually.`.

This plugin will dispatch a custom event called `sw.update` when the service worker has finished the update work. So in your site, you can choose to listen this event and popup a toast to remind users refreshing current page.

# Contribute

Fork this repository, make your changes and then issue a pull request. If you find bugs or have new ideas that you do not want to implement yourself, file a bug report.

# Copyright

Copyright (c) 2017 Pan Yuqi.

License: MIT

[ruby-gem]: https://rubygems.org/gems/jekyll-pwa-plugin
