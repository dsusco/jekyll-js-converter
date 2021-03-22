module Jekyll
  class JsSourceMapPage < Page
    def initialize(js_page)
      @site = js_page.site
      @dir  = js_page.dir
      @data = js_page.data
      @name = js_page.basename + '.js.map'

      process(@name)
      Jekyll::Hooks.trigger :pages, :post_init, self
    end

    def source_map(map)
      self.content = map
    end

    def ext
      '.map'
    end

    def asset_file?
      true
    end

    def inspect
      "#<#{self.class} @name=#{name.inspect}>"
    end
  end
end
