require 'uglifier'
require 'uri'
require 'jekyll/js_source_map_page'
require 'jekyll/core_ext/hash'

module Jekyll
  module Converters
    class Js < Converter
      DIRECTIVES = %w(import import_directory import_tree)

      safe true
      priority :low

      def associate_page(page)
        @page = page
        @source_map_page = JsSourceMapPage.new(@page)
      end

      def dissociate_page(page)
        @page = nil
        @site = nil
        @source_map_page = nil
      end

      def javascript_config
        @javascript_config ||= begin
          options = @config['javascript'] || {}

          options.deep_symbolize_keys
        end
      end

      def javascript_dir
        javascript_config[:javascript_dir].to_s.empty? ? '_javascript' : javascript_config[:javascript_dir]
      end

      def load_paths
        @load_paths ||= begin
          paths = [Jekyll.sanitized_path(site.source, javascript_dir)]
          paths += javascript_config[:load_paths].map { |load_path| File.expand_path(load_path, site.source) } rescue []

          if safe?
            paths.map! { |path| Jekyll.sanitized_path(site.source, path) }
          end

          Dir.chdir(site.source) do
            paths = paths.flat_map { |path| Dir.glob(path) }

            paths.map! do |path|
              if safe?
                Jekyll.sanitized_path(site.source, path)
              else
                File.expand_path(path)
              end
            end
          end

          paths.uniq!
          paths << site.theme.javascript_path if site.theme&.javascript_path
          paths.select { |path| File.directory?(path) }
        end
      end

      def matches(ext)
        ext =~ /^\.js$/i
      end

      def output_ext(ext = '')
        '.js'
      end

      def safe?
        !!@config['safe']
      end

      def convert(content)
        if generate_source_map?
          config = Jekyll::Utils.deep_merge_hashes(
            { :uglifier => {
                :source_map => {
                  :map_url => @source_map_page.name,
                  :sources_content => true,
                  :filename => @page.name
                }
              }
            },
            javascript_config
          )

          uglified, source_map = Uglifier.new(config[:uglifier]).compile_with_map(insert_imports(content))

          @source_map_page.source_map(source_map)
          site.pages << @source_map_page

          uglified
        else
          config = Jekyll::Utils.deep_merge_hashes(
            { :uglifier => {} },
            javascript_config
          )

          Uglifier.new(config[:uglifier]).compile(insert_imports(content))
        end
      end

      private

      def generate_source_map?
        if @page.nil? || source_map_option.eql?(:never)
          false
        elsif source_map_option.eql?(:always)
          true
        else
          :development == source_map_option && source_map_option == Jekyll.env.to_sym
        end
      end

      def insert_imports(content)
        content.enum_for(:scan, /^\/\/=\s*(\w+)\s+([\w\/\\\-\.:]+)\W*$/).map {
          { directive: Regexp.last_match[1],
            path: Regexp.last_match[2],
            insert_at: Regexp.last_match.end(0) }
        }.sort { |a, b|
          # start inserting at the end of the file so the insert_at's remain accurate as the content's length changes
          b[:insert_at] <=> a[:insert_at]
        }.each { |match|
          if DIRECTIVES.include?(match[:directive])
            import_content = load_paths.reduce([]) { |files, load_path|
              glob = case match[:directive]
              when 'import'
                if (match[:path] =~ URI::regexp).nil?
                  match[:path] += '.js' unless match[:path].end_with?('.js')
                  Dir.glob(File.join(load_path, '**', match[:path]))
                else
                  [match[:path]]
                end
              when 'import_directory'
                Dir.glob(File.join(load_path, '**', match[:path], '*.js'))
              when 'import_tree'
                Dir.glob(File.join(load_path, '**', match[:path], '**', '*.js'))
              end

              files + glob
            }.uniq.reduce('') { |import_content, file|
              import_content += (file =~ URI::regexp).nil? ? File.read(file) : Net::HTTP.get(URI(file))
            }

            content.insert(match[:insert_at], "\n#{insert_imports(import_content)}")
          end
        }

        content
      end

      def site
        @site ||= @page.nil? ? Jekyll.sites.last : @page.site
      end

      def source_map_option
        javascript_config.fetch(:source_map, :always).to_sym
      end
    end
  end
end
