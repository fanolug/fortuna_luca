require "minitest/autorun"
require "mocha/minitest"
require "minitest/reporters"
require "rack/test"
require "webmock/minitest"
require "mock_redis"
require_relative "../config/i18n"

ENV["RACK_ENV"] = "test"
ENV["SECRET_STRAVA_WEBHOOK_PATH"] = "/the-strava-secret-path"
ENV["STRAVA_CHAT_ID"] = "12345"
ENV["SECRET_WEBHOOK_PATH"] = "/the-secret-path"
ENV["SECRET_YT_WEBHOOK_PATH"] = "/the-yt-secret-path"
ENV["TELEGRAM_BOT_COMMAND"] = "/lucas"
ENV["YOUTUBE__abcdefg"] = '["-12345"]'
ENV["TWITTER_FOLLOWS"] ='{"12345": ["@first", "@second"]}'
ENV["TWITTER_MEDIA_FOLLOWS"] ='{"67890": ["@first", "@second"]}'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
