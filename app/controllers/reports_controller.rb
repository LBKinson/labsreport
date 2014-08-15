class ReportsController < ApplicationController

before_filter :authorize

# GA API access
def visitor 
  @SERVICE_ACCOUNT_EMAIL_ADDRESS = '154515577302-e7esj1h0cnnrmulevvujumjv1m3hjk9c@developer.gserviceaccount.com' # looks like 12345@developer.gserviceaccount.com
  @PATH_TO_KEY_FILE              = "#{Rails.root}/app/controllers/GA_Dashboard-1f3726b11932.p12"
  @PROFILE                       = 'ga:83059410' # your GA profile id, looks like 'ga:12345'

  require 'json'
  require 'google/api_client'

  # set up a client instance
  @client  = Google::APIClient.new

  @client.authorization = Signet::OAuth2::Client.new(
    :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    :audience             => 'https://accounts.google.com/o/oauth2/token',
    :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
    :issuer               => @SERVICE_ACCOUNT_EMAIL_ADDRESS,
    :signing_key          => Google::APIClient::PKCS12.load_key(@PATH_TO_KEY_FILE, 'notasecret')
  ).tap { |auth| auth.fetch_access_token! }

  @api_method = @client.discovered_api('analytics','v3').data.ga.get

end


def time
    # defines 'time' for header comparitive dates
    time = Time.new
    @weekday = time.strftime("%A")
    @today = time.strftime('%m/%d/%y')
   
    # WEEKLY DATES
    # real day minus 1 for data's sake
    @LW = (time-(60 * 60 * 24 * 7)).strftime('%m/%d/%y')
    @LW2 = (time-(60 * 60 * 24 * 14)).strftime('%m/%d/%y')
    @LW3 = (time-(60 * 60 * 24 * 8)).strftime('%m/%d/%y')


    # MONTHLY DATES
    # real day minus 1 for data's sake
    # Month to date
    @MTD = time.beginning_of_month.strftime('%m/%d/%y')
    @MTD2 = (time-(60 * 60 * 24 * 366)).beginning_of_month.strftime('%m/%d/%y')
    @MTD3 = (time-(60 * 60 * 24 * 366)).strftime('%m/%d/%y')

    # Month over month
    @LM = (time-(60 * 60 * 24 * 30)).strftime('%m/%d/%y')
    @LM2 = (time-(60 * 60 * 24 * 60)).strftime('%m/%d/%y')
    @LM3 = (time-(60 * 60 * 24 * 31)).strftime('%m/%d/%y')


    # YEARLY DATES
    # real day minus 1 for data's sake
    # Year to date
    @YTD = time.beginning_of_year.strftime('%m/%d/%y')
    @YTD2 = (time-(60 * 60 * 24 * 366)).beginning_of_year.strftime('%m/%d/%y')
    @YTD3 = (time-(60 * 60 * 24 * 366)).strftime('%m/%d/%y')

    # Year over year
    @LY = (time-(60 * 60 * 24 * 365)).strftime('%m/%d/%y')
    @LY2 = (time-(60 * 60 * 24 * 730)).strftime('%m/%d/%y')
    @LY3 = (time-(60 * 60 * 24 * 366)).strftime('%m/%d/%y')

end


  def report
    time
  end

  def weekly
    time
    visitor

    @result = @client.execute(:api_method => @api_method, :parameters => {
    'ids'        => @PROFILE,
    'start-date' => Date.new(1970,1,1).to_s,
    'end-date'   => Date.today.to_s,
    'dimensions' => 'ga:pagePath',
    'metrics'    => 'ga:pageviews',
    'filters'    => 'ga:pagePath==/url/to/user'
  })
  end

  def monthly  
    time
    visitor
  end

  def yearly
    time
    visitor
  end

end