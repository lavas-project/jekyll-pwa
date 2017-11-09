Gem::Specification.new do |s|
  s.name        = 'jekyll-pwa-plugin'
  s.version     = '1.0.0'
  s.date        = '2017-11-09'
  s.summary     = "PWA support for Jekyll."
  s.description = "This plugin provides PWA support for Jekyll. Generate a service worker and provides precache with Google Workbox."
  s.authors     = ["Pan Yuqi"]
  s.email       = 'pyqiverson@gmail.com'
  s.files       = ["lib/jekyll-pwa-plugin.rb", "lib/vendor/broadcast-channel-polyfill.js", "lib/vendor/workbox-sw.prod.v2.1.1.js"]
  s.homepage    =
    'https://github.com/lavas-project/jekyll-pwa'
  s.license       = 'MIT'
end
