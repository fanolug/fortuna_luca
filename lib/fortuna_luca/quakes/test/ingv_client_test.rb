require "date"
require_relative "../../../../test/test_helper"
require_relative "../ingv_client"

describe FortunaLuca::Quakes::INGVClient do
  let(:instance) { FortunaLuca::Quakes::INGVClient.new }
  let(:redis_instance) { MockRedis.new }

  describe '#call' do
    let(:api_response) do
      File.read(File.dirname(__FILE__) + '/fixtures/api_response.xml')
    end
    let(:expected_result) do
      [
        FortunaLuca::Quakes::INGVClient::Event.new(
          id: "33378441",
          url: "http://terremoti.ingv.it/event/33378441",
          description: "Costa Marchigiana Pesarese (Pesaro-Urbino)",
          time: DateTime.parse("2022-11-14T23:10:55.070000"),
          latitude: "43.9477",
          longitude: "13.3335",
          depth: "7400",
          magnitude: "3.5"
        ),
        FortunaLuca::Quakes::INGVClient::Event.new(
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
      stub_request(:get, FortunaLuca::Quakes::INGVClient::URL).to_return(body: api_response)
      Redis.stubs(:new).returns(redis_instance)
    end

    it 'returns the array of events' do
      instance.call.must_equal(expected_result)
    end
  end
end
