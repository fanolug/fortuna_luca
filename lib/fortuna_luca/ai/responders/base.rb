require_relative "../../logging"

module FortunaLuca
  module AI
    module Responders
      class Base
        include FortunaLuca::Logging

        # @param result [Google::Cloud::Dialogflow::V2::QueryResult]
        # param language [String]
        def initialize(result, language = I18n.locale)
          @result = result
          @language = language
        end

        private

        attr_reader :result, :language
      end
    end
  end
end
