Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = :i18n
Money.default_currency= 'USD'

# COMMENT OUT THIS BLOCK ONCE JOB IS SETUP, TELL BIEN ABOUT THIS
opexr_fetch_response = HTTParty.get("https://v6.exchangerate-api.com/v6/#{ENV["OPEXRATES_API_KEY"]}/pair/USD/PHP")
if opexr_fetch_response['result'] == "success"
  opexr_usd_php_exchange_rate = opexr_fetch_response['conversion_rate']
  Money.add_rate('USD', 'PHP', opexr_usd_php_exchange_rate)
  puts 'EXCHANGE RATE ADDED'
end