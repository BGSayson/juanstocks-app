class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @stocks = Stock.all
    opexr_fetch_response = HTTParty.get("https://v6.exchangerate-api.com/v6/#{ENV["OPEXRATES_API_KEY"]}/pair/USD/PHP")
    if opexr_fetch_response['result'] == "success"
      @opexr_usd_php_exchange_rate = opexr_fetch_response['conversion_rate']
    end
  end

  def show
    @stock = Stock.find(params[:id])
  end
end
