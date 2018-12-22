module CallLogger
  class CallLogger
    attr_reader :formatter, :logger

    def initialize(formatter:, logger: )
      @formatter = formatter
      @logger = logger
    end

    def log(method, args)
      logger.call(formatter.before(method, args))
      result = yield
      logger.call(formatter.after(method, result))
      result
    rescue StandardError => e
      logger.call(formatter.error(method, e))
      raise
    end
  end
end
