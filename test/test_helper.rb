require "minitest/autorun"
require "mocha/mini_test"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
