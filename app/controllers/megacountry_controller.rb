class MegacountryController < ApplicationController

# before_filter :authorize

# GA API access
# def visitor 
#   @SERVICE_ACCOUNT_EMAIL_ADDRESS = '' # looks like 12345@developer.gserviceaccount.com
#   @PATH_TO_KEY_FILE              = "#{Rails.root}/app/controllers/GA_Dashboard-1f3726b11932.p12"
#   @PROFILE                       = '' # your GA profile id, looks like 'ga:12345'


#   require 'json'
#   require 'google/api_client'

#   # set up a client instance
#   @client  = Google::APIClient.new

#   @client.authorization = Signet::OAuth2::Client.new(
#     :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
#     :audience             => 'https://accounts.google.com/o/oauth2/token',
#     :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
#     :issuer               => @SERVICE_ACCOUNT_EMAIL_ADDRESS,
#     :signing_key          => Google::APIClient::PKCS12.load_key(@PATH_TO_KEY_FILE, 'notasecret')
#   ).tap { |auth| auth.fetch_access_token! }

#   @api_method = @client.discovered_api('analytics','v3').data.ga.get

# end

def time
    # defines 'time' for header comparitive dates
    time = Time.new
    @weekday = time.strftime("%A")
    @header_today = time.strftime('%Y-%m-%d')
    
    # real day minus 1 for data's sake
    @today = (time-(60 * 60 * 24 * 1)).strftime('%Y-%m-%d')
   
    # WEEKLY DATES
    # real day minus 1 for data's sake
    @LW = (time-(60 * 60 * 24 * 7)).strftime('%Y-%m-%d')
    @LW2 = (time-(60 * 60 * 24 * 14)).strftime('%Y-%m-%d')
    @LW3 = (time-(60 * 60 * 24 * 8)).strftime('%Y-%m-%d')


    # MONTHLY DATES
    # real day minus 1 for data's sake
    # Month to date
    @MTD = time.beginning_of_month.strftime('%Y-%m-%d')
    @MTD2 = (time-(60 * 60 * 24 * 366)).beginning_of_month.strftime('%Y-%m-%d')
    @MTD3 = (time-(60 * 60 * 24 * 366)).strftime('%Y-%m-%d')

    # Month over month
    @LM = (time-(60 * 60 * 24 * 30)).strftime('%Y-%m-%d')
    @LM2 = (time-(60 * 60 * 24 * 60)).strftime('%Y-%m-%d')
    @LM3 = (time-(60 * 60 * 24 * 31)).strftime('%Y-%m-%d')


    # YEARLY DATES
    # real day minus 1 for data's sake
    # Year to date
    @YTD = time.beginning_of_year.strftime('%Y-%m-%d')
    @YTD2 = (time-(60 * 60 * 24 * 366)).beginning_of_year.strftime('%Y-%m-%d')
    @YTD3 = (time-(60 * 60 * 24 * 366)).strftime('%Y-%m-%d')

    # Year over year
    @LY = (time-(60 * 60 * 24 * 365)).strftime('%Y-%m-%d')
    @LY2 = (time-(60 * 60 * 24 * 730)).strftime('%Y-%m-%d')
    @LY3 = (time-(60 * 60 * 24 * 366)).strftime('%Y-%m-%d')

end


def mc
	time
end

def mcweekly
	time
	# visitor
end

def mcmonthly
	time
	# visitor
end

def mcyearly
	time
	# visitor
end




end