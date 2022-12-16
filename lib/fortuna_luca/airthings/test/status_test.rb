# frozen_string_literal: true

require_relative "../../../../test/test_helper"
require_relative "../status"

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
  let(:expected_result) do
    "*Ufficio*: T 17.2°, Umidità 65% 🟡, Radon 33 Bq/m³ 🟢\n*Camera*: T 16.2°, Umidità 71% 🔴, VOC 65 ppb 🟢, Rischio muffa 2/10"
  end

  before do
    FortunaLuca::Airthings::Client.any_instance.expects(:samples).returns(samples)
  end

  it 'returns the array of events' do
    instance.airthings_status.must_equal(expected_result)
  end
end
