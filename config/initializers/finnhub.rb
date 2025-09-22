require 'finnhub_ruby'

FinnhubRuby.configure do |config|
  config.api_key['api_key'] = ENV["FINNHUB_API_KEY"]
end

# PUT THIS SOMEWHERE ELSE FOR API CALLS
# finnhub_client = FinnhubRuby::DefaultApi.new
