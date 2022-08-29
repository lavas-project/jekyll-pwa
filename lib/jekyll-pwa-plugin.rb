class SWHelper
    WORKBOX_VERSION = 'v5.1.4'
    def initialize(site, config)
        @site = site
        @config = config
        @sw_filename = @config['sw_dest_filename'] || 'service-worker.js'
        @sw_src_filepath = @config['sw_src_filepath'] || 'service-worker.js'
    end

    def write_sw_register()
        sw_register_filename = 'sw-register.js'
        sw_register_file = File.new(@site.in_dest_dir(sw_register_filename), 'w')
        # add build version in url params
        sw_register_file.puts(
        <<-SCRIPT
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('#{@site.baseurl.to_s}/#{@sw_filename}?v=#{@site.time.to_i.to_s}').then(function(reg) {
                reg.onupdatefound = function() {
                    var installingWorker = reg.installing;
                    installingWorker.onstatechange = function() {
                        switch (installingWorker.state) {
                            case 'installed':
                                if (navigator.serviceWorker.controller) {
                                    var event = new Event('sw.update');
                                    window.dispatchEvent(event);
                                }
                                break;
                        }
                    };
                };
            }).catch(function(e) {
                console.error('Error during service worker registration:', e);
            });
        }
        SCRIPT
        )
        sw_register_file.close
    end

    def generate_workbox_precache()
        directory = @config['precache_glob_directory'] || '/'
        directory = @site.in_dest_dir(directory)
        patterns = @config['precache_glob_patterns'] || ['**/*.{html,js,css,eot,svg,ttf,woff}']
        ignores = @config['precache_glob_ignores'] || []
        recent_posts_num = @config['precache_recent_posts_num']

        # according to workbox precache {url: 'main.js', revision: 'xxxx'}
        @precache_list = []

        # find precache files with glob
        precache_files = []
        patterns.each do |pattern|
            Dir.glob(File.join(directory, pattern)) do |filepath|
                precache_files.push(filepath)
            end
        end
        precache_files = precache_files.uniq

        # precache recent n posts
        posts_path_url_map = {}
        if recent_posts_num
            precache_files.concat(
                @site.posts.docs
                    .reverse.take(recent_posts_num)
                    .map do |post|
                        posts_path_url_map[post.path] = post.url
                        post.path
                    end
            )
        end

        # filter with ignores
        ignores.each do |pattern|
            Dir.glob(File.join(directory, pattern)) do |ignored_filepath|
                precache_files.delete(ignored_filepath)
            end
        end

        # generate md5 for each precache file
        md5 = Digest::MD5.new
        precache_files.each do |filepath|
            md5.reset
            md5 << File.read(filepath)
            if posts_path_url_map[filepath]
                url = posts_path_url_map[filepath]
            else
                url = filepath.sub(@site.dest, '')
            end
            @precache_list.push({
                url: @site.baseurl.to_s + url,
                revision: md5.hexdigest
            })
        end
    end

    def write_sw()

        dest_js_directory = @config['dest_js_directory'] || 'js'

        # copy polyfill & workbox.js to js/
        script_directory = @site.in_dest_dir(dest_js_directory)
        FileUtils.mkdir_p(script_directory) unless Dir.exist?(script_directory)
        FileUtils.cp_r(File.expand_path('../vendor/', __FILE__) + '/.', script_directory)

        # generate precache list
        precache_list_str = @precache_list.map do |precache_item|
            precache_item.to_json
        end
        .join(",")

        # write service-worker.js
        sw_src_file_str = File.read(@site.in_source_dir(@sw_src_filepath))
        workbox_dir = File.join(@site.baseurl.to_s, dest_js_directory, "workbox-#{SWHelper::WORKBOX_VERSION}")
        import_scripts_str = 
        <<-SCRIPT
            importScripts("#{workbox_dir}/workbox-sw.js");
            workbox.setConfig({modulePathPrefix: "#{workbox_dir}"});
        SCRIPT

        sw_dest_file = File.new(@site.in_dest_dir(@sw_filename), 'w')
        sw_dest_file.puts(
        <<-SCRIPT
            #{import_scripts_str}
            self.__precacheManifest = [#{precache_list_str}];
            #{sw_src_file_str}
        SCRIPT
        )
        sw_dest_file.close
    end

    def self.insert_sw_register_into_body(page)
        page.output = page.output.sub('</body>',
        <<-SCRIPT
            <script>
                window.onload = function () {
                    var script = document.createElement('script');
                    var firstScript = document.getElementsByTagName('script')[0];
                    script.type = 'text/javascript';
                    script.async = true;
                    script.src = '#{page.site.baseurl.to_s}/sw-register.js?v=' + Date.now();
                    firstScript.parentNode.insertBefore(script, firstScript);
                };
            </script>
            </body>
        SCRIPT
        )
    end
end

module Jekyll

    Hooks.register :pages, :post_render do |page|
      enabled = (page.site.config.dig('pwa', 'enabled') != false)
      if enabled
        # append <script> for sw-register.js in <body>
        SWHelper.insert_sw_register_into_body(page)
      end
    end

    Hooks.register :documents, :post_render do |document|
      enabled = (document.site.config.dig('pwa', 'enabled') != false)
      if enabled
        # append <script> for sw-register.js in <body>
        SWHelper.insert_sw_register_into_body(document)
      end
    end

    Hooks.register :site, :post_write do |site|
      enabled = (site.config.dig('pwa', 'enabled') != false)
      if enabled
        pwa_config = site.config['pwa'] || {}
        sw_helper = SWHelper.new(site, pwa_config)

        sw_helper.write_sw_register()
        sw_helper.generate_workbox_precache()
        sw_helper.write_sw()
      end
    end

end
