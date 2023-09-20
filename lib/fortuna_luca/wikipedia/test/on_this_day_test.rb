require_relative "../../../../test/test_helper"
require_relative "../on_this_day"

describe FortunaLuca::Wikipedia::OnThisDay do
  let(:instance) { FortunaLuca::Wikipedia::OnThisDay.new("it") }
  let(:stubbed_response) { HTTP::Message.new_response(data) }

  describe "#call" do
    subject { instance.call(month: '09', day: '20', type: 'selected') }

    before do
      HTTPClient.stubs(:get).with(
        "https://api.wikimedia.org/feed/v1/wikipedia/it/onthisday/selected/09/20"
      ).returns(stubbed_response)
    end

    describe "with valid data returned" do
      let(:data) do
        File.read(File.dirname(__FILE__) + '/fixtures/wikipedia_on_this_day.json')
      end

      it "returns the Wikipedia on this day info" do
        subject.must_equal(JSON.parse(data)["selected"])
      end
    end

    describe "with invalid JSON data returned" do
      let(:data) { "" }

      it "returns nil" do
        subject.must_equal(nil)
      end
    end

    describe "with blank data returned" do
      let(:data) { '{}' }

      it "returns nil" do
        subject.must_equal(nil)
      end
    end
  end
end
