require "dotenv/load"

module FortunaLuca
  module Logging
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger
      Logging.logger
    end
  end
end
