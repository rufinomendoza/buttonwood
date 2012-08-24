require 'json'
require 'net/http'
require 'bigdecimal'

class Holding < ActiveRecord::Base
  attr_accessible :portfolio_id, :security_id, :shares_held
  belongs_to :portfolio
  belongs_to :security

  def summary
      @summary ||= retrieve_from_yahoo
  end
  
  def indicator(key)
    summary["#{key}"]
  end

  def key_indicators 
    indicator("LastTradePriceOnly")
    indicator("MarketCapitalization")
    indicator("PERatio")
  end

  def dollar_value_currency
    currency(dollar_value)
  end

  def dollar_value
    value = indicator("LastTradePriceOnly").to_f * shares_held.to_f
  end

  def currency(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "$", :precision => 0)
  end

  def currency_dec(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "$", :precision => 2)
  end  

  def commas(n)
    ActionController::Base.helpers.number_to_currency(n, :unit => "", :precision => 0)
  end  

  def percent_dec(n)
    ActionController::Base.helpers.number_to_percentage(n, :precision => 2)
  end

  def asset_total
    array = []
    @holdings.each do |holding|
      array << holding.dollar_value
    end
    assets = array.sum
    asset_total = number_to_currency(assets)
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
