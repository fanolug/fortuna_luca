require "date"
require_relative "../../../../test/test_helper"
require_relative "../client"

describe FortunaLuca::Quakes::Client do
  let(:instance) do
    Class.new do
      include FortunaLuca::Quakes::Client
    end.new
  end
  let(:redis_instance) { MockRedis.new }

  describe '#quake_events' do
    let(:api_response) do
      File.read(File.dirname(__FILE__) + '/fixtures/api_response.xml')
    end
    let(:expected_result) do
      [
        FortunaLuca::Quakes::Client::Event.new(
          id: "33378441",
          url: "http://terremoti.ingv.it/event/33378441",
          description: "Costa Marchigiana Pesarese (Pesaro-Urbino)",
          time: DateTime.parse("2022-11-14T23:10:55.070000"),
          latitude: "43.9477",
          longitude: "13.3335",
          depth: "7400",
          magnitude: "3.5"
        ),
        FortunaLuca::Quakes::Client::Event.new(
          id: "33389921",
          url: "http://terremoti.ingv.it/event/33389921",
          description: "Costa Marchigiana Anconetana (Ancona)",
          time: DateTime.parse("2022-11-16T08:57:08.040000"),
          latitude: "43.934",
          longitude: "13.337",
          depth: "4400",
          magnitude: "3.2"
        )
      ]
    end

    before do
      stub_request(:get, FortunaLuca::Quakes::Client::URL).to_return(body: api_response)
      Redis.stubs(:new).returns(redis_instance)
    end

    it 'returns the array of events' do
      instance.quake_events.must_equal(expected_result)
    end
  end
end
