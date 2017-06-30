require "api-ai-ruby"

module ApiaiClient
  def ai_response_to(text)
    begin
      response = apiai_client.text_request(text)
      logger.debug(response.inspect) if ENV["DEVELOPMENT"]
      handle_response(response)
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

  def handle_response(response)
    # direct speech response
    speech = response.dig(:result, :fulfillment, :speech)
    return speech if speech && speech != ""

    # no speech response
    case response.dig(:result, :action)
    when "weather" then handle_weather_response(response)
    else
      # TODO nothing?
    end
  end

  def handle_weather_response(response)
    address = response.dig(:result, :parameters, :address)
    city = address.respond_to?(:dig) ? address.dig(:city) : address
    city = fallback_weather_city if !city || city == ""

    time = response.dig(:result, :parameters, :"date-time")
    time = fallback_weather_time if !time || time == ""

    forecast = summary_forecast_for(city, Date.parse(time).to_time)
    return if !forecast
    "A #{city} #{forecast.downcase}"
  end

  def fallback_weather_city
    "Fano"
  end

  def fallback_weather_time
    (Time.now + 12 * 3600).to_s
  end
end
