# frozen_string_literal: true

require_relative "redis/client"

module FortunaLuca
  # Saves processed IDs on Redis to avoid double processing
  module ProcessedIDs
    include FortunaLuca::Redis::Client

    private

    def processed_ids_redis_key
      raise NotImplementedError, "#processed_ids_redis_key must be implemented"
    end

    # @return [Boolean] false if the ID was already processed, true otherwise.
    def process_once(id)
      return false if processed_ids.include?(id)

      result = yield
      push_processed_id(id)
      result
    end

    def push_processed_id(id)
      redis.rpush(processed_ids_redis_key, id)
    end

    def processed_ids
      redis.lrange(processed_ids_redis_key, 0, -1)
    end
  end
end
