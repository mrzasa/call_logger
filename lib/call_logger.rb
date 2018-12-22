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

  def log(method, args, &block)
    call_logger = ::CallLogger::CallLogger.new(logger: ::CallLogger.configuration.logger, formatter: ::CallLogger.configuration.formatter)
    call_logger.log(method, args, &block)
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
