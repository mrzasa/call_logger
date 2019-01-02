require "call_logger/version"

require 'call_logger/formatter'
require 'call_logger/logger'
require 'call_logger/configuration'
require 'call_logger/call_wrapper'
require 'call_logger/method_wrapper'

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

  def log_block(name, &block)
    self.class.log_block(name, &block)
  end

  module ClassMethods
    def log(*methods)
      wrap_log(self, methods)
    end

    def log_class(*methods)
      wrap_log(singleton_class, methods)
    end

    def log_block(name, &block)
      do_log(name, [], &block)
    end

    def wrap_log(owner, methods)
      wrapper = MethodWrapper.new(owner, self)
      if methods.size == 1 && owner.respond_to?(methods.first)
        wrapper.wrap_single(methods.first)
      else
        wrapper.wrap_multiple(methods)
      end
    end

    def do_log(method, args, &block)
      logger = ::CallLogger.configuration.logger
      formatter = ::CallLogger.configuration.formatter
      call_wrapper = ::CallLogger::CallWrapper.new(
        logger: logger, formatter: formatter
      )
      call_wrapper.call(method, args, &block)
    end
  end
end
