SERVICE_ACCOUNT_EMAIL_ADDRESS = '154515577302-e7esj1h0cnnrmulevvujumjv1m3hjk9c@developer.gserviceaccount.com' # looks like 12345@developer.gserviceaccount.com
PATH_TO_KEY_FILE              = '/app/assets/api/GA_Dashboard-1f3726b11932.p12' # the path to the downloaded .p12 key file
PROFILE                       = '83059410' # your GA profile id, looks like 'ga:12345'


# respond_to :json

# def visitors

#   # set up a client instance
#   client  = ::Google::APIClient.new
#   client.authorization = Signet::OAuth2::Client.new(
#       :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
#       :audience             => 'https://accounts.google.com/o/oauth2/token',
#       :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
#       :issuer               => SERVICE_ACCOUNT_EMAIL_ADDRESS,
#       :signing_key          => Google::APIClient::KeyUtils.load_from_pkcs12(PATH_TO_KEY_FILE, 'notasecret')
#   ).tap { |auth| auth.fetch_access_token! }

#   api_method = client.discovered_api('analytics','v3').data.ga.get

#   # make queries
#   result = client.execute(:api_method => api_method, :parameters => {
#       'ids'        => PROFILE,
#       'start-date' => "28daysAgo",
#       'end-date'   => "today",
#       'dimensions' => 'ga:week',
#       'metrics'    => 'ga:users'
#   })

#   respond_with result.data.rows
# end
































require 'json'
require 'google/api_client'

# set up a client instance
client  = Google::APIClient.new

client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience             => 'https://accounts.google.com/o/oauth2/token',
  :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
  :issuer               => SERVICE_ACCOUNT_EMAIL_ADDRESS,
  :signing_key          => Google::APIClient::PKCS12.load_key(PATH_TO_KEY_FILE, 'notasecret')
).tap { |auth| auth.fetch_access_token! }

api_method = client.discovered_api('analytics','v3').data.ga.get


# make queries
result = client.execute(:api_method => api_method, :parameters => {
  'ids'        => PROFILE,
  'start-date' => Date.new(1970,1,1).to_s,
  'end-date'   => Date.today.to_s,
  'dimensions' => 'ga:pagePath',
  'metrics'    => 'ga:pageviews',
  'filters'    => 'ga:pagePath==/url/to/user'
})

puts result.data.rows.inspect