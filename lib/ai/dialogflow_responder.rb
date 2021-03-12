require_relative "../logging"

module AI
  module DialogflowResponder
    include Logging

    def initialize(response, language = I18n.locale)
      @response = response
      @language = language
    end

    private

    attr_reader :response, :language
  end
end
