# frozen_string_literal: true

require "redis"
require "connection_pool"

module FortunaLuca
  module Redis
    module Client
      def redis
        $redis ||= ConnectionPool::Wrapper.new do
          ::Redis.new(url: ENV["REDIS_URL"])
        end
      end
    end
  end
end
