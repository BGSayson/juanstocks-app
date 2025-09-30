require "finnhub_ruby"
require "redis"
# require 'sidekiq'

class FinnhubJob < ApplicationJob
  queue_as :default

  def perform
    redis = Redis.new(host: "localhost", port: 6379)

    puts "Starting stock price update job..."
    client = FinnhubRuby::DefaultApi.new

    Stock.find_each do |stock|
      begin
        # `Rails.cache.fetch` will first try to find a result in Redis with the given key.
        quote = Rails.cache.fetch("stock-quote-#{stock.symbol}", expires_in: 3.minutes) do
          # This block of code ONLY runs if there is a "cache miss"
          # (i.e., the key is not found in Redis or has expired).
          puts "Cache missing: Fetching fresh quote for #{stock.symbol} from Finnhub API."
          data = client.quote(stock.symbol)
          puts stock.symbol
          puts data.inspect
          sleep(1.1) # Stay under the 60 calls/minute rate limit.
          data # Return the data to be cached.
        end
        # cp2 = Rails.cache.fetch("stock-company-profile2-#{stock.symbol}", expires_in: 3.minutes) do

        # If there was a "cache hit", the code above instantly returns the cached value
        # from Redis, and the block is completely skipped.

        # Now, update the database with the (potentially cached) quote data.
        stock.update!(
          current_price_cents:          quote["c"],
          change:                       quote["d"],
          percent_change:               quote["dp"],
          high_price_of_the_day_cents:  quote["h"],
          low_price_of_the_day_cents:   quote["l"]
        )
        rescue StandardError => e
        Rails.logger.error "Finnhub API error for #{stock.symbol}: #{e.message}"
        next
      end
    end
    puts "Finished stock price update job."
  end
end
