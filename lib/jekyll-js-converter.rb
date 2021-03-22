require 'jekyll-js-converter/version'
require 'jekyll/converters/js'

module JekyllJsConverter
  class Jekyll::Theme
    def javascript_path
      @javascript_path ||= path_for '_javascript'
    end
  end

  Jekyll::Hooks.register :pages, :pre_render do |page|
    if page.is_a?(Jekyll::Page)
      page.converters.each do |converter|
        converter.associate_page(page) if converter.is_a?(Jekyll::Converters::Js)
      end
    end
  end

  Jekyll::Hooks.register :pages, :post_render do |page|
    if page.is_a?(Jekyll::Page)
      page.converters.each do |converter|
        converter.dissociate_page(page) if converter.is_a?(Jekyll::Converters::Js)
      end
    end
  end
end
