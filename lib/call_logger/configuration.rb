module CallLogger
  class Configuration
    attr_accessor :logger, :formatter

    def logger
      @logger || ::CallLogger::Logger.new
    end

    def formatter
      @formatter || ::CallLogger::Formatter.new
    end
  end
end
