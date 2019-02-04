require 'benchmark'

module CallLogger
  class CallWrapper
    attr_reader :formatter, :logger

    def initialize(formatter:, logger: )
      @formatter = formatter
      @logger = logger
    end

    def call(name, args)
      logger.call(formatter.before(name, args))
      result = nil
      seconds = Benchmark.realtime { result = yield }
      logger.call(formatter.after(name, result, seconds: seconds))
      result
    rescue StandardError => e
      logger.call(formatter.error(name, e))
      raise
    end
  end
end
