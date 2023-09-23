require_relative "../../../../../test/test_helper"

describe FortunaLuca::Telegram::Wikipedia::OnThisDay do
  let(:instance) do
    FortunaLuca::Telegram::Wikipedia::OnThisDay.new(
      language: "it",
      month: "09",
      day: "20",
      type: "selected"
    )
  end
  let(:stubbed_response) do
    [
      {
        "year" => "2023",
        "text" => "new event"
      },
      {
        "year" => "2022",
        "text" => "old event"
      }
    ]
  end

  before do
    FortunaLuca::Wikipedia::OnThisDay.any_instance.expects(:call).returns(stubbed_response)
  end

  describe "#call" do
    it "sends the formatted Telegram message" do
      ::Telegram::Bot::Api.any_instance.expects(:send_message).with(
        chat_id: "12345",
        text: "Accadde oggi 20/09...\n2022: old event\n2023: new event"
      )
      instance.call
    end
  end
end
