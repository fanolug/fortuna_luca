require 'i18n'

I18n.available_locales = [:it]
I18n.default_locale = :it
I18n.load_path = Dir[File.expand_path('**/locales/*.yml')]
