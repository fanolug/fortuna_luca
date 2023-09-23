module FortunaLuca
  module AI
    module Responders
      class ChatGPT < Base
        def call
          query = result.query_text
          return if query.to_s == ""

          FortunaLuca::OpenAI::ChatGPTClient.new.call(query)
        end
      end
    end
  end
end
