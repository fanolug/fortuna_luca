require_relative '../lib/fortuna_luca/telegram/wikipedia/on_this_day'

task :send_wikipedia_on_this_day do
  now = Time.now
  month = "%02d" % now.month
  day = "%02d" % now.day

  FortunaLuca::Telegram::Wikipedia::OnThisDay.new(
    language: "it",
    month: month,
    day: day,
    type: "selected"
  ).call
end
