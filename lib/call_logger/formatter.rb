module CallLogger
  class Formatter
    def before(method, args)
      "#{method}(#{args.join(', ')})"
    end

    def after(method, result, seconds: nil)
      "#{method} => #{result}, [Took: #{'%.6f' % seconds}s]"
    end

    def error(method, exception)
      "#{method} !! #{exception}"
    end
  end
end
