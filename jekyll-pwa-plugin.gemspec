Gem::Specification.new do |s|
  s.name        = 'jekyll-pwa-plugin'
  s.version     = '5.1.4'
  s.date        = '2021-01-03'
  s.summary     = "PWA support for Jekyll."
  s.description = "This plugin provides PWA support for Jekyll. Generate a service worker and provides precache with Google Workbox."
  s.authors     = ["Pan Yuqi"]
  s.email       = 'pyqiverson@gmail.com'
  s.files       = Dir["lib/*.rb"] + Dir["lib/vendor/**/*"]
  s.homepage    =
    'https://github.com/lavas-project/jekyll-pwa'
  s.license       = 'MIT'
end
