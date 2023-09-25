require_relative "../../../test/test_helper"

describe FortunaLuca::Geo do
  let(:instance) do
    Class.new do
      include FortunaLuca::Geo
    end.new
  end

  describe "#coordinates_for" do
    subject { instance.coordinates_for("Fano") }

    let(:coordinates) { ["43.8441", "13.0170"] }
    let(:result) { [OpenStruct.new(coordinates: coordinates)] }

    it "calls geocoder" do
      ::Geocoder.expects(:configure).with(timeout: 10)
      ::Geocoder::Query.any_instance.expects(:execute).returns(result)

      subject.must_equal(coordinates)
    end
  end
end
