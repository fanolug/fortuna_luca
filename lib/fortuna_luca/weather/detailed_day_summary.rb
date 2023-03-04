# frozen_string_literal: true

require 'date'
require_relative "day_summary"

module FortunaLuca
  module Weather
    class DetailedDaySummary < DaySummary
      MORNING = 7
      AFTERNOON = 13
      EVENING = 19
      COMMUTING = [7, 14, 15]

      # @param location [String]
      # @param date [Date]
      # @param show_commuting [Bool] Show commuting text if true
      def initialize(location:, date:, show_commuting: false)
        @location = location
        @lat, @lon = coordinates_for(location)
        @date = date
        @show_commuting = show_commuting
      end

      def call
        if hourly_data.none?
          return DaySummary.new(location: location, date: date).call
        end

        morning = [
          I18n.t(main_code(morning_data), scope: 'weather.codes'),
          precipitations(morning_data),
          temperature(morning_data)
        ].compact.join(", ")
        afternoon = [
          I18n.t(main_code(afternoon_data), scope: 'weather.codes'),
          precipitations(afternoon_data),
          temperature(afternoon_data)
        ].compact.join(", ")
        evening = [
          I18n.t(main_code(evening_data), scope: 'weather.codes'),
          precipitations(evening_data),
          temperature(evening_data)
        ].compact.join(", ")
        day = [
          I18n.t('weather.detailed_day_summary.pressure', value: data.pressure),
          I18n.t('weather.detailed_day_summary.humidity', value: data.humidity)
        ].join(", ")

        <<~TEXT
          #{I18n.t('weather.detailed_day_summary.morning')} #{morning} #{main_icon(morning_data)}
          #{I18n.t('weather.detailed_day_summary.afternoon')} #{afternoon} #{main_icon(afternoon_data)}
          #{I18n.t('weather.detailed_day_summary.evening')} #{evening} #{main_icon(evening_data)}
          #{day}
          #{commuting}
        TEXT
      end

      private

      attr_reader :location, :show_commuting

      def hourly_data
        @hourly_data ||= forecast.hourly.select do |data|
          Time.at(data.time).to_date == date
        end
      end

      def morning_data
        @morning_data ||= hourly_data.select do |data|
          Time.at(data.time).hour.between?(MORNING, AFTERNOON - 1)
        end
      end

      def afternoon_data
        @afternoon_data ||= hourly_data.select do |data|
          Time.at(data.time).hour.between?(AFTERNOON, EVENING - 1)
        end
      end

      def evening_data
        @evening_data ||= hourly_data.select do |data|
          Time.at(data.time).hour > EVENING
        end
      end

      def main_code(data)
        data.flat_map(&:codes).tally.sort_by do |_value, count|
          count
        end.reverse.first.first
      end

      def main_icon(data)
        icons_for([main_code(data)]).join
      end

      def precipitations(data)
        max = data.map { |d| d.precipitations.probability }.max
        return if max < 10

        max_rain = data.map { |d| d.precipitations.rain }.max
        max_snow = data.map { |d| d.precipitations.snow }.max
        what = [
          (I18n.t('weather.detailed_day_summary.rain') if max_rain > 0),
          (I18n.t('weather.detailed_day_summary.snow') if max_snow > 0)
        ].compact.join(" #{I18n.t('weather.and')} ")
        what = I18n.t('weather.detailed_day_summary.precipitations') if what == ""

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
        return if !show_commuting

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
    end
  end
end
