module CallLogger
  class MethodWrapperBuilder
    attr_reader :klass, :wrapped_class

    def initialize(klass, wrapped_class)
      @klass = klass
      @wrapped_class = wrapped_class
    end

    def wrap_single(method)
      builder = self
      klass.alias_method "#{method}_without_log", method
      klass.define_method method do |*args|
        builder.wrapped_class.do_log("#{builder.wrapped_class}#{builder.separator}#{method}", args) do
          send("#{method}_without_log", *args)
        end
      end
    end

    def wrap_multi(methods)
      builder = self
      klass.prepend(Module.new do
        methods.each do |method|
          define_method method do |*args|
            builder.wrapped_class.do_log("#{builder.wrapped_class}#{builder.separator}#{method}", args) do
              super(*args)
            end
          end
        end
      end)
    end

    def separator
      if klass.singleton_class?
        '.'
      else
        '#'
      end
    end
  end
end
