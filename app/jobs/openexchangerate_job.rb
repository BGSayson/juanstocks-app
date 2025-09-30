# require 'sidekiq'

class OpenexchangerateJob < ApplicationJob
  queue_as :default

  def perform
    redis = Redis.new(host: "localhost", port: 6379)

    Wallet.find_each do |wallet|
      begin
        exchange_rate = Rails.cache.fetch("USD/PHP exchange rate", expires_in: 3.minutes) do
          opexr_fetch_response = HTTParty.get("https://v6.exchangerate-api.com/v6/#{ENV["OPEXRATES_API_KEY"]}/pair/USD/PHP")
              if opexr_fetch_response["result"] == "success"
                opexr_usd_php_exchange_rate = opexr_fetch_response["conversion_rate"]
                puts "Cache missing: Fetching latest exchange rate for USD/PHP."
                data = opexr_usd_php_exchange_rate
                puts "latest exchange rate : #{data}"
                data
              end
          end
          if Money.default_bank.get_rate("USD", "PHP") == nil
            Money.add_rate("USD", "PHP", exchange_rate)
          else
            Money.default_bank.set_rate("USD", "PHP", exchange_rate)
          end
        rescue => e
          Rails.logger.error "Exchange Rate API error: #{e.message}"
        end
    end
    puts "Finished updating exchange rate between USD/PHP at #{Time.now}."
  end
end
