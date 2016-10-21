#!/usr/bin/ruby
require 'dotenv'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

Dotenv.load

module GoogleClient
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
