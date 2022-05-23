class Hash
  def deep_symbolize_keys(object = self)
    case object
      when Hash
        object.each_with_object(Hash.new) do |(key, value), result|
          result[key.to_sym] = deep_symbolize_keys(value)
        end
      else
        object
    end
  end
end
