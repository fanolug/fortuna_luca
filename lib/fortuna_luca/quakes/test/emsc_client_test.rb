require "date"
require_relative "../../../../test/test_helper"

describe FortunaLuca::Quakes::EMSCClient do
  let(:instance) { FortunaLuca::Quakes::EMSCClient.new }
  let(:redis_instance) { MockRedis.new }

  describe "#call" do
    let(:api_response) do
      File.read(File.dirname(__FILE__) + "/fixtures/emsc_api_response.xml")
    end
    let(:expected_result) do
      [
        FortunaLuca::Quakes::EMSCClient::Event.new(
          id: "20230922_0000053",
          url: "https://seismicportal.eu/eventdetails.html?unid=20230922_0000053",
          description: "CENTRAL ITALY",
          time: DateTime.parse("2023-09-22T05:35:14.31Z"),
          latitude: "42.4610",
          longitude: "13.2875",
          depth: "14500.0",
          magnitude: "3.0"
        )
      ]
    end

    before do
      stub_request(:get, "https://seismicportal.eu/fdsnws/event/1/query").to_return(body: api_response)
      Redis.stubs(:new).returns(redis_instance)
    end

    it "returns the array of events" do
      instance.call.must_equal(expected_result)
    end
  end
end
