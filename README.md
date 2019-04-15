# Jekyll PWA Plugin [![Gem Version](https://badge.fury.io/rb/jekyll-pwa-plugin.png)](http://badge.fury.io/rb/jekyll-pwa-plugin)

> PWA support for Jekyll

This plugin provides PWA support for Jekyll. Generate a service worker and provides precache and runtime cache with Google Workbox.

Google Workbox has already developed a series of [tools](https://developers.google.com/web/tools/workbox/). If you use Webpack or Gulp as your build tool, you can easily generate a service worker with these tools. But in my blog, I don't want to use even npm, and I want to precache recent 10 posts so that they are offline available to visitors even though these posts were never opened by visitors before. That's why I try to integrate this function in Jekyll build process.

**IMPORTANT** This plugin supports Workbox V4 since `v3.0.1`.

If you used `v1.x.x` before, a migration guide is [HERE](./MIGRATE.md).
The API of Workbox V3 has changed a lot compared with V2, some more powerful functions added too.
I really recommend applying an migration.  
Here's the [v1 Doc](./README-v1.md).

If you use `v2.x.x`, the [Doc is also available](./README-v2.md). Some breaking change also prevent v2 configurations to work with v3. Follow the [release notes of Workbox](https://github.com/GoogleChrome/workbox/releases) to understand the changes.

**Curent Workbox Version**: 4.3.0

This plugin has been used in [my blog](https://xiaoiver.github.io) so that you can see the effect.

## Installation

This plugin is available as a [RubyGem][ruby-gem].

### Option #1

Add `gem 'jekyll-pwa-plugin'` to the `jekyll_plugin` group in your `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'jekyll'

group :jekyll_plugins do
  gem 'jekyll-pwa-plugin'
end
```

Then run `bundle` to install the gem.

### Option #2

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

### Configuration

Add the following configuration block to Jekyll's `_config.yml`:
```yaml
pwa:
  sw_src_filepath: service-worker.js # Optional
  sw_dest_filename: service-worker.js # Optional
  dest_js_directory: assets/js # Required
  precache_recent_posts_num: 5 # Optional
  precache_glob_directory: / # Optional
  precache_glob_patterns: # Optional
    - "{js,css,fonts}/**/*.{js,css,eot,svg,ttf,woff}"
    - index.html
  precache_glob_ignores: # Optional
    - sw-register.js
    - "fonts/**/*"
```

Parameter                 | Description
----------                | ------------
sw_src_filepath           | Filepath of the source service worker. Defaults to `service-worker.js`
sw_dest_filename          | Filename of the destination service worker. Defaults to `service-worker.js`
dest_js_directory         | Directory of JS in `_site`. During the build process, some JS like workbox.js will be copied to this directory so that service worker can import them in runtime.
precache_glob_directory   | Directory of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_glob_patterns    | Patterns of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_glob_ignores     | Ignores of precache. [Workbox Config](https://developers.google.com/web/tools/workbox/get-started/webpack#optional-config)
precache_recent_posts_num | Number of recent posts to precache.

We handle precache and runtime cache with the help of Google Workbox v3.6.3 in service worker.

### Write your own Service Worker

Create a `service-worker.js` in the root path of your Jekyll project.
You can change this source file's path with `sw_src_filepath` option.

Now you can write your own Service Worker with [Workbox APIs](https://developers.google.com/web/tools/workbox/reference-docs/latest/).

Here's what the `service-worker.js` like in my site.
```javascript
// service-worker.js

// set names for both precache & runtime cache
workbox.core.setCacheNameDetails({
    prefix: 'my-blog',
    suffix: 'v1',
    precache: 'precache',
    runtime: 'runtime-cache'
});

// let Service Worker take control of pages ASAP
workbox.core.skipWaiting()
workbox.core.clientsClaim()

// let Workbox handle our precache list
workbox.precaching.precacheAndRoute(self.__precacheManifest);

// use `networkFirst` strategy for `*.html`, like all my posts
workbox.routing.registerRoute(
    /\.html$/,
    new workbox.strategies.NetworkFirst()
);

// use `cacheFirst` strategy for images
workbox.routing.registerRoute(
    /assets\/(img|icons)/,
    new workbox.strategies.CacheFirst()
);

// third party files
workbox.routing.registerRoute(
    /^https?:\/\/cdn.staticfile.org/,
    new workbox.strategies.StaleWhileRevalidate()
);
```

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
