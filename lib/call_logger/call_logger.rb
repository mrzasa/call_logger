module CallLogger
  class CallLogger
    attr_reader :formatter, :logger

    def initialize(formatter:, logger: )
      @formatter = formatter
      @logger = logger
    end

    def log(method, args)
      logger.call(formatter.begin_message(method, args))
      result = yield
      logger.call(formatter.end_message(method, result))
      result
    end
  end
end
