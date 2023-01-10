# frozen_string_literal: true

require 'date'
require 'holidays'
require_relative "day_summary"

module FortunaLuca
  module Weather
    class DetailedDaySummary < DaySummary
      MORNING = 7
      AFTERNOON = 13
      EVENING = 19
      COMMUTING = [7, 14, 15]

      def call
        morning = [
          text_summary(morning_data),
          precipitations(morning_data),
          temperature(morning_data)
        ].compact.join(", ")
        morning_icons = icons_for(morning_data.flat_map(&:codes)).uniq.join
        afternoon = [
          text_summary(afternoon_data),
          precipitations(afternoon_data),
          temperature(afternoon_data)
        ].compact.join(", ")
        afternoon_icons = icons_for(afternoon_data.flat_map(&:codes)).uniq.join
        evening = [
          text_summary(evening_data),
          precipitations(evening_data),
          temperature(evening_data)
        ].compact.join(", ")
        evening_icons = icons_for(evening_data.flat_map(&:codes)).uniq.join
        day = [
          I18n.t('weather.detailed_day_summary.pressure', value: data.pressure),
          I18n.t('weather.detailed_day_summary.humidity', value: data.humidity)
        ].join(", ")

        <<~TEXT
          #{I18n.t('weather.detailed_day_summary.morning')} #{morning} #{morning_icons}
          #{I18n.t('weather.detailed_day_summary.afternoon')} #{afternoon} #{afternoon_icons}
          #{I18n.t('weather.detailed_day_summary.evening')} #{evening} #{evening_icons}
          #{day}
          #{commuting}
        TEXT
      end

      private

      def morning_data
        @morning_data ||= forecast.hourly.select do |data|
          Time.at(data.time).hour.between?(MORNING, AFTERNOON - 1)
        end
      end

      def afternoon_data
        @afternoon_data ||= forecast.hourly.select do |data|
          Time.at(data.time).hour.between?(AFTERNOON, EVENING - 1)
        end
      end

      def evening_data
        @evening_data ||= forecast.hourly.select do |data|
          Time.at(data.time).hour > EVENING
        end
      end

      def text_summary(data)
        values = data.flat_map(&:codes)
        grouped = values.tally.sort_by { |_value, count| count }
        I18n.t(grouped.first.first, scope: 'weather.codes')
      end

      def precipitations(data)
        max = data.map { |d| d.precipitations.probability }.max
        return if max < 10

        max_rain = data.map { |d| d.precipitations.rain }.max
        max_snow = data.map { |d| d.precipitations.snow }.max
        what = if max_rain > 0
          I18n.t('weather.detailed_day_summary.rain')
        elsif max_snow > 0
          I18n.t('weather.detailed_day_summary.snow')
        end

        I18n.t(
          'weather.detailed_day_summary.precip_probability_up_to',
          value: max,
          what: what
        )
      end

      def temperature(data)
        average = (data.sum { |d| d.temperatures.max }.to_f / data.size).round

        I18n.t('weather.detailed_day_summary.temp', value: average)
      end

      def commuting
        return if holiday?(date)

        data = forecast.hourly.select do |data|
          time = Time.at(data.time)
          time.to_date == date && COMMUTING.include?(time.hour)
        end
        max_probability = data.map { |d| d.precipitations.probability }.max
        min_temp = data.map { |d| d.temperatures.min }.min

        result = if max_probability < 25
          I18n.t('weather.detailed_day_summary.commuting.ok')
        elsif max_probability < 50
          I18n.t('weather.detailed_day_summary.commuting.maybe')
        elsif max_probability < 75
          I18n.t('weather.detailed_day_summary.commuting.risky')
        else
          I18n.t('weather.detailed_day_summary.commuting.ko')
        end
        cold_alert = if max_probability < 75
          if min_temp < 10
            I18n.t('weather.detailed_day_summary.commuting.cold_alert')
          elsif min_temp < 2
            I18n.t('weather.detailed_day_summary.commuting.very_cold_alert')
          end
        end

        [result, cold_alert].compact.join(" ")
      end

      def holiday?(date)
        date.saturday? || date.sunday? || Holidays.on(date, :it).any?
      end
    end
  end
end
