module CallLogger
  class Formatter
    def before(method, args)
      "#{method}(#{args.join(', ')})"
    end

    def after(method, result)
      "#{method} => #{result}"
    end

    def error(method, exception)
      "#{method} !! #{exception}"
    end
  end
end
