# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Getting Stock Data from Finnhub"

def stocks_dataset
  nasdaq_top_thirty = [ 'NVDA', 'MSFT', 'AAPL', 'AMZN', 'JPM', 'WMT', 'V', 'JNJ', 'HD', 'PG', 'CVX', 'UNH', 'KO', 'CSCO', 'GS', 'IBM', 'AXP', 'CRM', 'CAT', 'MCD', 'DIS', 'MRK', 'VZ', 'BA', 'AMGN', 'HON', 'NKE', 'SHW', 'MMM', 'TRV' ]

  begin
    finnhub_client = FinnhubRuby::DefaultApi.new
    nasdaq_top_thirty.each do |symbol|
      company_profile = finnhub_client.company_profile2({ symbol: symbol }) # fetches company profile | required : symbol
      puts "fetching data for #{company_profile['name']}"
      sleep(1.1)
      stock_quote = finnhub_client.quote(symbol) # fetches stock quote | required : symbol

      Stock.create(
        currency: company_profile['currency'], # currency
        description: company_profile['name'], # company name
        display_symbol: company_profile['logo'], # logo url
        symbol: company_profile['ticker'], # ticker

        current_price: stock_quote['c'],
        change: stock_quote['d'],
        percent_change: stock_quote['dp'],
        high_price_of_the_day: stock_quote['h'],
        low_price_of_the_day: stock_quote['l'],
        open_price_of_the_day: stock_quote['o'],
        previous_close_price: stock_quote['pc']
      )
    end
  rescue StandardError => e
    if e.class.to_s == 'FinnhubRuby::ApiError'
      puts "Finnhub API Error: #{e.message}. Rolling back stock creations."
    else
      puts "Error: #{e.message}. Rolling back all stock creations."
    end
    raise ActiveRecord::Rollback
  rescue => e
    puts "Error: #{e.message}. Rolling back all stock creations."
    raise ActiveRecord::Rollback
  end
end

stocks_dataset() unless Rails.env.test?
puts "Stock Data Seeded"
