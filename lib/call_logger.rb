require "call_logger/version"

module CallLogger
  def self.included(base)
    base.extend(ClassMethods)
  end

  def log(method, args)
    puts "Method #{method} called with #{args}"
    result = yield
    puts "Method #{method} returned #{result}"
    result
  end

  module ClassMethods
    def log(method)
      alias_method "#{method}_without_log", method
      define_method method do |*args|
        log(method, args) do
          send("#{method}_without_log", *args)
        end
      end
    end
  end
end
