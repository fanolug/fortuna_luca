module FortunaLuca
  module Logging
    def self.logger
      @logger ||= begin
        if ENV["RACK_ENV"] == "test"
          ::Logger.new('log/test.log')
        else
          ::Logger.new(STDOUT)
        end
      end
    end

    def logger
      Logging.logger
    end
  end
end
