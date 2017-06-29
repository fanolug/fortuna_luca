#!/usr/bin/ruby
require 'dotenv'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

Dotenv.load

module GoogleClient
  def send_next_event
    # Initialize the API
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = GoogleCalendarAPI.new.authorize
    # Fetch the next events for the user
    calendar_id = "#{ENV['IDCAL']}"
    response = service.list_events(calendar_id,
                                   max_results: 1,
                                   single_events: true,
                                   order_by: 'startTime',
                                   time_min: Time.now.iso8601)

    response.items.each do |event|
      start = event.start.date || event.start.date_time
      case start.strftime('%Y%m%d%H%M')
      when Time.now.strftime('%Y%m%d%H%M')
        send_message(ENV['CHAT_ID'], "#{event.summary}")
      end
    end
  end

  class GoogleCalendarAPI
  	OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
  	APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
  	CLIENT_SECRETS_PATH = 'client_secret.json'
  	CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
  															 "calendar-ruby-quickstart.yaml")
  	SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

  	##
  	# Ensure valid credentials, either by restoring from the saved credentials
  	# files or intitiating an OAuth2 authorization. If authorization is required,
  	# the user's default browser will be launched to approve the request.
  	#
  	# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  	def authorize
  		FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  		client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  		token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  		authorizer = Google::Auth::UserAuthorizer.new(
  			client_id, SCOPE, token_store)
  		user_id = 'default'
  		credentials = authorizer.get_credentials(user_id)
  		if credentials.nil?
  			url = authorizer.get_authorization_url(
  				base_url: OOB_URI)
  			code = "#{ENV['CALAUTHCODE']}"
  			credentials = authorizer.get_and_store_credentials_from_code(
  				user_id: user_id, code: code, base_url: OOB_URI)
  		end
  		credentials
  	end
  end
end
