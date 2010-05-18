class Object
  alias_method :__default__methods__, :methods

  def methods
    return __default__methods__.sort
  end

  def distinct_methods
    return (__default__methods__ - Object.methods).sort
  end
end

