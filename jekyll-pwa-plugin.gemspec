Gem::Specification.new do |s|
  s.name        = 'jekyll-pwa-plugin'
  s.version     = '1.0.2'
  s.date        = '2018-07-05'
  s.summary     = "PWA support for Jekyll."
  s.description = "This plugin provides PWA support for Jekyll. Generate a service worker and provides precache with Google Workbox."
  s.authors     = ["Pan Yuqi"]
  s.email       = 'pyqiverson@gmail.com'
  s.files       = ["lib/jekyll-pwa-plugin.rb", "lib/vendor/workbox-sw.prod.v2.1.1.js"]
  s.homepage    =
    'https://github.com/lavas-project/jekyll-pwa'
  s.license       = 'MIT'
end
