require_relative "base"
require_relative "../../openai/dall_e_client"

module FortunaLuca
  module AI
    module Responders
      class DallE < Base
        def call
          query = result.parameters.fields["query"].string_value
          return if query.to_s == ""

          FortunaLuca::OpenAI::DallEClient.new.call(query)
        end
      end
    end
  end
end
