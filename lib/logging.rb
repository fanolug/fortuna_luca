require "dotenv/load"

module Logging
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def logger
    Logging.logger
  end
end
