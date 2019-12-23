require "dotenv/load"

module Logging
  def self.logger
    @logger ||= Logger.new(ENV["DEVELOPMENT"] ? STDOUT : "log/production.log")
  end

  def logger
    Logging.logger
  end
end
