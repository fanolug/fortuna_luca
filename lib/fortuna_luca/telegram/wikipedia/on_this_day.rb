# frozen_string_literal: true

module FortunaLuca
  module Telegram
    module Wikipedia
      class OnThisDay
        include Logging
        include FortunaLuca::Telegram::Client

        # @param result [Array<Hash>] The API response items
        def initialize(language:, month:, day:, type:)
          @language = language
          @month = month
          @day = day
          @type = type
        end

        def call
          return if !response || response.size == 0

          items = response.sort_by { |item| item["year"] }.map { |item| message_from(item) }
          message = [
            "<b>#{I18n.t("wikipedia.on_this_day.title", month: month, day: day)}</b>",
            items
          ].flatten.join("\n")

          chat_ids.each do |chat_id|
            send_telegram_message(
              chat_id,
              message,
              parse_mode: 'HTML',
              disable_web_page_preview: true,
              disable_notification: true
            )
          end
        end

        private

        attr_reader :language, :month, :day, :type

        def response
          @response ||= FortunaLuca::Wikipedia::OnThisDay.new(language).call(
            month: month,
            day: day,
            type: type
          )
        end

        def chat_ids
          JSON.parse(env_or_blank("WIKIPEDIA_ON_THIS_DAY_CHAT_IDS"))
        end

        def env_or_blank(key)
          ENV[key] || "[]"
        end

        def message_from(item)
          text = "<i>#{item["year"]}</i>: #{item["text"]}"
          return text unless item["pages"]

          linked_terms = []
          item["pages"].sort_by do |page|
            page["titles"]["normalized"].length
          end.reverse.each do |page|
            url = page["content_urls"]["desktop"]["page"]
            term = page["titles"]["normalized"]

            next if linked_terms.any? do |linked_term|
              linked_term.downcase.include?(term.downcase)
            end

            text.gsub!(/#{term}/i, "<a href='#{url}'>#{term}</a>")
            linked_terms << term
          end

          text
        end
      end
    end
  end
end
