require "call_logger/version"

require 'call_logger/formatter'
require 'call_logger/logger'
require 'call_logger/configuration'
require 'call_logger/method_wrapper'
require 'call_logger/method_wrapper_builder'

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
      wrap_log(self, methods)
    end

    def log_class(*methods)
      wrap_log(singleton_class, methods)
    end

    def wrap_log(owner, methods)
      builder = MethodWrapperBuilder.new(owner, self)
      if methods.size == 1 && owner.respond_to?(methods.first)
        builder.wrap_single(methods.first)
      else
        builder.wrap_multi(methods)
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
