## Migration Guide

Some options in `_config.yml` have changed.

### Create your own Service Worker

You need to create a `service-worker.js` in the root path of your Jekyll project.
Of cause the path can be changed with `sw_src_filepath` option.

**IMPORTANT** `sw_filename` rename to `sw_dest_filename`.

### Set Cache name

**IMPORTANT** `cache_name` has been removed.

Instead, you can set names for both precache & runtime cache in `service-worker.js`:
```javascript
// service-worker.js

workbox.core.setCacheNameDetails({
    prefix: 'my-blog',
    suffix: 'v1',
    precache: 'precache',
    runtime: 'runtime-cache'
});
```

When Service Worker runs, two caches will be created: 
* `my-blog-precache-v1 - http://mysite`
* `my-blog-runtime-cache-v1 - http://mysite`

### Use precache list

All the `precache_` config remain the same. This plugin will generate a precache list according to `precache_` config.

But you need to call `precacheAndRoute` in `service-worker.js`:
```javascript
// service-worker.js

// let Workbox handle our precache list
workbox.precaching.precacheAndRoute(self.__precacheManifest);
```

If you want to modify this list in Service Worker runtime, you can use `Array.filter` like this:
```javascript
// service-worker.js

// let Workbox handle our precache list
workbox.precaching.precacheAndRoute(self.__precacheManifest
    .filter(function(manifest) {
        // ignore .js files
        return !/\.js$/.test(manifest.url)
    });
```

### Remove `runtime_cache` config

We remove all the options relative to `runtime_cache` in `_config.yml`.

You can write these rules directly in `service-worker` with [Workbox Routing API](https://developers.google.com/web/tools/workbox/reference-docs/latest/workbox.routing.Router#registerRoute).

For example, you can remove the following config:
```yaml
# _config.yml

pwa:
    runtime_cache:
        - route: /^api\/getdata/
            strategy: networkFirst
```

Instead, use Workbox API in your `service-worker.js`:
```javascript
// service-worker.js

workbox.routing.registerRoute(
    /^api\/getdata/,
    workbox.strategies.networkFirst()
);
```

### Notes

Workbox V3 will use **development** version when it detects your site is under `localhost`, and some usefull logs for debug will be printed in console.

Don't worry because Workbox will switch to **production** mode when your site is pushed online.
