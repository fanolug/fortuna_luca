require_relative "../logging"

module AI
  module DialogflowResponder
    include Logging

    def initialize(response)
      @response = response
    end

    private

    attr_reader :response
  end
end
