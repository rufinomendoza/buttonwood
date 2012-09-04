require 'json'
require 'net/http'
require 'bigdecimal'

class Holding < ActiveRecord::Base
  attr_accessible :portfolio_id, :security_id, :shares_held
  belongs_to :portfolio
  belongs_to :security
  validates :security_id, :uniqueness => { :scope => :portfolio_id }
  validates :shares_held, :presence => true

  # Indicators

  def indicator(key)
    summary["#{key}"]
  end

  def name
    indicator("Name")
  end

  def indicator_currency(key)
    Format.currency(indicator(key).to_f)
  end

  def indicator_currency_dec(key)
    Format.currency_dec(indicator(key).to_f)
  end

  def indicator_comma_dec(key)
    Format.comma_dec(indicator(key).to_f)
  end

  def indicator_percent_dec(key)
    Format.percent_dec(indicator(key).to_f)
  end

  def weight(assets)
    Format.percent_dec(dollar_value/assets*100)
  end

  # Getting info from API

  def summary
    @summary ||= retrieve_from_yahoo
  end

  # Methods for table
  
  def dollar_value_currency
    Format.currency(dollar_value)
  end

  def dollar_value
    value = indicator("LastTradePriceOnly").to_f * shares_held.to_f
  end

  def dollar_value_yesterday
    value = indicator("PreviousClose").to_f * shares_held.to_f
  end

  # More Complicated Methods
  def premium
    Format.percent_dec((indicator("LastTradePriceOnly").to_f/security.our_price_target.to_f-1)*100)
  end


  # Importing these Security methods into Holding model

  def sector_name_for_holdings
    security.sector_name
  end

  def symbol
    security.symbol
  end

  def last_px
    indicator("LastTradePriceOnly").to_f
  end

  def our_price_target
    Format.currency_dec(security.our_price_target)
  end

  def our_current_year_eps
    Format.comma_dec(security.our_current_year_eps)
  end

  def our_next_year_eps
    Format.comma_dec(security.our_next_year_eps)
  end

  def portfolio_name
    portfolio.name
  end

  def bv
    indicator("BookValue").to_f
  end

  def dps
    indicator("DividendShare")
  end

  def eps
    indicator("EarningsShare").to_f
  end

  def fy1_consensus_eps
    indicator("EPSEstimateCurrentYear")
  end

  def fy2_consensus_eps
    indicator("EPSEstimateNextYear")
  end

  def trailing_pb
    last_px/bv
  end

  def trailing_pe
    last_px/eps
  end
  
  private

  def retrieve_from_yahoo
    url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%3D%22#{symbol}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    resp = Net::HTTP.get_response(URI.parse(url))
    body = JSON.parse(resp.body)
    pretty = JSON.pretty_generate(body)
    parsed = JSON.parse(pretty)
    unless parsed.blank?
      Rails.cache.delete('yahooapi')
      Rails.cache.write('yahooapi', parsed)
    end
    almost = Rails.cache.read('yahooapi')
    result = almost["query"]["results"]["quote"]
  end
end