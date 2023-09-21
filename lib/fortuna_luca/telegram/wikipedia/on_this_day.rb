# frozen_string_literal: true

require "dotenv/load"
require "i18n"
require_relative '../client'
require_relative '../../logging'
require_relative '../wikipedia/on_this_day'

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

          items = response.sort_by do |item|
            item["year"]
          end.map do |item|
            "#{item["year"]}: #{item["text"]}"
          end
          message = [I18n.t("wikipedia.on_this_day.title"), items].flatten.join("\n")

          chat_ids.each do |chat_id|
            send_telegram_message(chat_id, message)
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
      end
    end
  end
end
