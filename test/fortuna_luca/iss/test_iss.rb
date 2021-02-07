require_relative "../../test_helper"
require_relative "../../../lib/fortuna_luca/iss/when"

describe FortunaLuca::Iss::When do
  let(:instance) { FortunaLuca::Iss::When.new() }
  let(:stubbed_response) { HTTP::Message.new_response(data) }

  describe "#call" do
    before do
      HTTPClient.stubs(:get).with(
        "http://api.open-notify.org/iss-pass.json?lat=43.8789729&lon=12.9601665&n=5",
      ).returns(stubbed_response)
    end

    describe "with valid data returned" do
      let(:data) do
        File.read(File.dirname(__FILE__) + '/../../fixtures/iss_when.json')
      end

      it "returns the Iss when" do
        instance.call().must_equal(
          "passa il 06/02 alle 19:47 ed è visibile per 6 minuti"
        )
      end
    end

    describe "with invalid JSON data returned" do
      let(:data) { "" }

      it "returns nil" do
        instance.call().must_equal(nil)
      end
    end

  end
end
