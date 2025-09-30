class ExchangeRateJob
  include Sidekiq::Job

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
                sleep(10)
                puts "latest exchange rate : #{data}"
                data
              end
          end
        rescue => e
          Rails.logger.error "Exchange Rate API error: #{e.message}"
        end
        wallet.update!(
          usd_exchange_rate:        exchange_rate
        )
    puts "#{exchange_rate}"
    end
    puts "Finished updating exchange rate between USD/PHP at #{Time.now}."
  end
end
