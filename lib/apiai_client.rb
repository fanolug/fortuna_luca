require "api-ai-ruby"

module ApiaiClient
  def ai_response_to(text)
    begin
      response = apiai_client.text_request(text)
      logger.debug(response.inspect) if ENV["DEVELOPMENT"]
      handle_ai_response(response)
    rescue ApiAiRuby::ClientError, ApiAiRuby::RequestError => e
      e.message
    end
  end

  private

  def apiai_client
    @apiai_client ||= ApiAiRuby::Client.new(
      client_access_token: ENV["APIAI_TOKEN"],
      api_lang: ENV["APIAI_LANG"]
    )
  end

  def handle_ai_response(response)
    # direct speech response
    speech = response.dig(:result, :fulfillment, :speech)
    return speech if speech && speech != ""
  end
end
