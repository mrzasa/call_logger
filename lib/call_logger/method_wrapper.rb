module CallLogger
  class MethodWrapper
    attr_reader :extended_class, :owner_class

    def initialize(extended_class, owner_class)
      @extended_class = extended_class
      @owner_class = owner_class
    end

    def wrap_single(method)
      owner = @owner_class
      sep = separator
      extended_class.alias_method "#{method}_without_log", method
      extended_class.define_method method do |*args|
        owner.do_log("#{owner}#{sep}#{method}", args) do
          send("#{method}_without_log", *args)
        end
      end
    end

    def wrap_multiple(methods)
      extended_class.prepend(build_module(methods))
    end

    private

    def separator
      if extended_class.singleton_class?
        '.'
      else
        '#'
      end
    end

    def build_module(methods)
      owner = @owner_class
      sep = separator
      Module.new do
        methods.each do |method|
          define_method method do |*args|
            owner.do_log("#{owner}#{sep}#{method}", args) do
              super(*args)
            end
          end
        end
      end
    end
  end
end
