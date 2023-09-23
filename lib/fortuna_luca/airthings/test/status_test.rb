# frozen_string_literal: true

require_relative "../../../../test/test_helper"

describe FortunaLuca::Airthings::Status do
  let(:instance) do
    Class.new do
      include FortunaLuca::Airthings::Status
    end.new
  end
  let(:samples) do
    {
      "Ufficio" => {
        "battery" => 100,
        "humidity" => 65.0,
        "radonShortTermAvg" => 33.0,
        "rssi" => -54,
        "temp" => 17.2,
        "time" => 1671181766,
        "relayDeviceType" => "hub"
      },
      "Camera" => {
        "battery" => 100,
        "humidity" => 71.0,
        "mold" => 2.0,
        "rssi" => -68,
        "temp" => 16.2,
        "time" => 1671181733,
        "voc" => 65.0,
        "relayDeviceType" => "hub"
      }
    }
  end

  before do
    FortunaLuca::Airthings::Client.any_instance.expects(:samples).returns(samples)
  end

  describe '#airthings_status' do
    let(:expected_result) do
      "<pre>Ufficio: 17.2°, 65% 🟡, Rn 33Bq/m³ 🟢</pre>\n<pre>Camera:  16.2°, 71% 🔴, VOC 65ppb 🟢, Muffa 2/10</pre>"
    end

    it 'returns the formatted text report' do
      instance.airthings_status.must_equal(expected_result)
    end
  end
end
