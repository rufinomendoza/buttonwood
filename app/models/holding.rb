require 'json'
require 'net/http'
require 'bigdecimal'
require 'open-uri'
require 'ostruct'
require 'csv'

class Holding < ActiveRecord::Base
  attr_accessible :portfolio_id, :security_id, :shares_held
  belongs_to :portfolio
  belongs_to :security
  validates :security_id, :uniqueness => { :scope => :portfolio_id }
  validates :shares_held, :presence => true


  # Getting info from API

  def summary
    @summary ||= retrieve_from_yahoo
  end

  # Catch all method for calling Indicators from API

  def indicator(key)
    summary["#{key}"]
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

  # Common methods across Holdings

  def name
    indicator("Name")
  end

  def weight(assets)
    Format.percent_dec(dollar_value/assets*100)
  end

  def portfolio_name
    portfolio.name
  end

  def sector_name_for_holdings
    security.sector_name
  end

  def symbol
    security.symbol
  end

  # Methods for Summary
  
  def dollar_value_currency
    Format.currency(dollar_value)
  end

  def dollar_value
    value = indicator("LastTradePriceOnly").to_f * shares_held.to_f
  end

  def dollar_value_yesterday
    value = indicator("PreviousClose").to_f * shares_held.to_f
  end

  def last_px
    indicator("LastTradePriceOnly").to_f
  end

  # Methods for Fundamental Indicators

  def our_price_target
    Format.currency_dec(security.our_price_target)
  end

  def premium
    Format.percent_dec((indicator("LastTradePriceOnly").to_f/security.our_price_target.to_f-1)*100)
  end

  def our_current_year_eps
    Format.comma_dec(security.our_current_year_eps)
  end

  def our_next_year_eps
    Format.comma_dec(security.our_next_year_eps)
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

  # # Methods for Historical Data and Performance
  
  def today_price
    one_year_series[:adjusted_close].first.to_f
  end

  def today_date
    one_year_series[:trade_date].first
  end

  # One Year

  def one_year_series
    read_historical(symbol, Time::now - 1.year, Time::now,{ :period => "d" })
  end

  def one_year_ago_price
    one_year_series[:adjusted_close].last.to_f
  end

  def one_year_ago_date
    one_year_series[:trade_date].last
  end

  def one_year_performance
    (today_price/one_year_ago_price-1)*100
  end

  # Three Year

  def three_year_series
    read_historical(symbol, Time::now - 3.years, Time::now,{ :period => "d" })
  end

  def three_years_ago_price
    three_year_series[:adjusted_close].last.to_f
  end

  def three_years_ago_date
    three_year_series[:trade_date].last
  end

  def three_year_performance
    one = (Date.strptime(today_date, '%Y-%m-%d') - Date.strptime(one_year_ago_date, '%Y-%m-%d')).to_f
    three = (Date.strptime(today_date, '%Y-%m-%d') - Date.strptime(three_years_ago_date, '%Y-%m-%d')).to_f
    (((today_price/three_years_ago_price)**(one/three))-1)*100
  end

  # Five Year

  def five_year_series
    read_historical(symbol, Time::now - 5.years, Time::now,{ :period => "d" })
  end

  def five_years_ago_price
    five_year_series[:adjusted_close].last.to_f
  end

  def five_years_ago_date
    five_year_series[:trade_date].last
  end

  def five_year_performance
    one = (Date.strptime(today_date, '%Y-%m-%d') - Date.strptime(one_year_ago_date, '%Y-%m-%d')).to_f
    five = (Date.strptime(today_date, '%Y-%m-%d') - Date.strptime(five_years_ago_date, '%Y-%m-%d')).to_f
    (((today_price/five_years_ago_price)**(one/five))-1)*100
  end

  private

  def retrieve_from_yahoo
    parsed = {}
    while parsed.blank? do
      url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%3D%22#{symbol}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
      resp = Net::HTTP.get_response(URI.parse(url))
      body = JSON.parse(resp.body)
      pretty = JSON.pretty_generate(body)
      parsed = JSON.parse(pretty)["query"]["results"]
    end
    result = parsed["quote"]
  end

  def read_historical(symbol, start_date, end_date, options)
     # got this from https://github.com/herval/yahoo-finance/blob/master/lib/yahoo_finance.rb
     url = "http://ichart.finance.yahoo.com/table.csv?s=#{URI.escape(symbol)}&d=#{end_date.month-1}&e=#{end_date.day}&f=#{end_date.year}&g=#{options[:period]}&a=#{start_date.month-1}&b=#{start_date.day}&c=#{start_date.year}&ignore=.csv"
     conn = open(url)
     cols =
       if options[:period] == :dividends_only
         [:dividend_pay_date, :dividend_yield]
       else
         [:trade_date, :open, :high, :low, :close, :volume, :adjusted_close]
       end
     result = CSV.parse(conn.read, :headers => cols) #:first_row, :header_converters => :symbol)
     result.delete(0)  # drop returned header
     result
  end
end
