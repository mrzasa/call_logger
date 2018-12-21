module CallLogger
  class Formatter
    def begin_message(method, args)
      "#{method}(#{args.join(', ')})"
    end

    # args?
    def end_message(method, result)
      "#{method} => #{result}"
    end
  end
end
