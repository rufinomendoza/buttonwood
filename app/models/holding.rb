require 'json'
require 'net/http'
require 'bigdecimal'

class Holding < ActiveRecord::Base
  attr_accessible :portfolio_id, :security_id, :shares_held
  belongs_to :portfolio
  belongs_to :security
  validates :security_id, :uniqueness => { :scope => :portfolio_id }
  validates :shares_held, :presence => true

  # Basic Methods

  def summary
    @summary ||= retrieve_from_yahoo
  end
  
  def indicator(key)
    summary["#{key}"]
  end

  def dollar_value_currency
    currency(dollar_value)
  end

  def dollar_value
    value = indicator("LastTradePriceOnly").to_f * shares_held.to_f
  end

  def dollar_value_yesterday
    value = indicator("PreviousClose").to_f * shares_held.to_f
  end

  # More Complicated Methods
  def premium
    percent_dec((indicator("LastTradePriceOnly").to_f/security.our_price_target.to_f-1)*100)
  end

  # Importing these Security methods into Holding model

  def sector_name_for_holdings
    security.sector_name
  end

  def symbol
    security.symbol
  end

  def our_price_target
    currency_dec(security.our_price_target)
  end

  def our_current_year_eps
    commas_dec(security.our_current_year_eps)
  end

  def our_next_year_eps
    commas_dec(security.our_next_year_eps)
  end

  def portfolio_name
    portfolio.name
  end

  # Formatting Methods

  def currency(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "$", :precision => 0)
  end

  def currency_dec(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "$", :precision => 2)
  end  

  def commas(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "", :precision => 0)
  end
  
  def commas_dec(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "", :precision => 2)
  end

  def percent(n)
    ActionController::Base.helpers.number_to_percentage(n, :precision => 0)
  end

  def percent_dec(n)
    ActionController::Base.helpers.number_to_percentage(n, :precision => 2)
  end

  # Might need these later
  # def assets(&block)
  #   assets = []
  #   self.each do |holding|
  #     assets << holding.dollar_value
  #   end
  #   assets = assets.sum
  # end

  def key_indicators_p_sh
    array = ["DividendShare","EarningsShare","EPSEstimateCurrentYear","EPSEstimateNextYear"]
  end

  def key_indicators
    array = ["EPSEstimateCurrentYear","EPSEstimateNextYear","DividendShare"]
  end
  
  private

  def retrieve_from_yahoo
    url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%3D%22#{security.symbol}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    resp = Net::HTTP.get_response(URI.parse(url))
    body = JSON.parse(resp.body)
    pretty = JSON.pretty_generate(body)
    parsed = JSON.parse(pretty)
    result = parsed["query"]["results"]["quote"]
  end
end