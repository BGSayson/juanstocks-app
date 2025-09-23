require 'httparty'
class OpenexchangerateJob < ApplicationJob
  queue_as :default

  # get an api key from this site https://app.exchangerate-api.com/dashboard

  def perform
    opexr_fetch_response = HTTParty.get("https://v6.exchangerate-api.com/v6/#{ENV["OPEXRATES_API_KEY"]}/pair/USD/PHP")
    if opexr_fetch_response['result'] == "success"
      opexr_usd_php_exchange_rate = opexr_fetch_response['conversion_rate']
      Money.add_rate('USD', 'PHP', opexr_usd_php_exchange_rate)
    end
  end
end
