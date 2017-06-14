require 'telegram/bot'

module TelegramClient
  def send_message(chat_id, text)
    begin
      telegram_client.api.send_message(chat_id: chat_id, text: text)
    rescue Telegram::Bot::Exceptions::ResponseError => exception
      logger.error "#{exception.message} (#send_message chat_id: #{chat_id}, text: #{text})"
    end
  end

  private

  def telegram_client(options = {})
    @telegram_client ||= Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'],
                                                   options.merge(logger: logger))
  end

  def run_telegram_loop
    loop do
      begin
        telegram_client.run do |bot|
          bot.listen do |message|
            handle_message(message)
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => exception
        logger.error "#{exception.message} (Telegram) (#run_telegram_loop)"
        handle_telegram_exception(exception)
      rescue Faraday::ClientError => exception
        logger.error "#{exception.message} (Faraday) (#run_telegram_loop)"
        try_reconnection
      end
    end
  end


  def handle_telegram_exception(exception)
    case exception.error_code
    when 403 # Forbidden. Ignore the message and keep going
      return
    when 409 # Conflict. Must exit process
      logger.info "Exiting."
      Process.exit
    end

    try_telegram_reconnection
  end

  def try_telegram_reconnection
    sleep 10
    @telegram_client = nil
  end
end