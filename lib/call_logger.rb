require "call_logger/version"

require 'call_logger/formatter'
require 'call_logger/logger'
require 'call_logger/configuration'
require 'call_logger/call_logger'

module CallLogger
  def self.included(base)
    base.extend(ClassMethods)
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?
  end
  configure # set defaults


  module ClassMethods
    def log(*methods)
      if methods.size == 1
        method = methods.first
        alias_method "#{method}_without_log", method
        define_method method do |*args|
          self.class.do_log("#{self.class}##{method}", args) do
            send("#{method}_without_log", *args)
          end
        end
      else
        self.prepend(Module.new do
          methods.each do |method|
            define_method method do |*args|
              self.class.do_log("#{self.class}##{method}", args) do
                super(*args)
              end
            end
          end
        end)
      end
    end

    #http://blog.jayfields.com/2008/04/alternatives-for-redefining-methods.html
    def new_log(*methods)
      methods.each do |method|
        old_method = instance_method(method)
        define_method method do |*args|
          self.class.do_log("#{self.class}##{method}", args) do
            old_method.bind(self).call(*args)
          end
        end
      end
    end

    def log_class(method)
      singleton_class.alias_method "#{method}_without_log", method
      singleton_class.define_method method do |*args|
        do_log("#{self}.#{method}", args) do
          send("#{method}_without_log", *args)
        end
      end
    end

    def do_log(method, args, &block)
      logger = ::CallLogger.configuration.logger
      formatter = ::CallLogger.configuration.formatter
      method_wrapper = ::CallLogger::MethodWrapper.new(
        logger: logger, formatter: formatter
      )
      method_wrapper.call(method, args, &block)
    end
  end
end
