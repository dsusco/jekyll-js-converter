module Jekyll
  class Theme
    def javascript_path
      @javascript_path ||= path_for '_javascript'
    end
  end
end
