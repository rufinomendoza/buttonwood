require 'json'
require 'net/http'
require 'BigDecimal'

class Tearsheet
  
  def initialize(ticker)
    @ticker = ticker
  end

  def ticker
    @ticker
  end

  def self.summary(ticker)
    url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%3D%22#{ticker}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    resp = Net::HTTP.get_response(URI.parse(url))
    body = JSON.parse(resp.body)
    pretty = JSON.pretty_generate(body)
    parsed = JSON.parse(pretty)
    result = parsed["query"]["results"]["quote"]
  end
  
  def self.lambda(key, ticker)
    summary(ticker)["#{key}"]
  end
end

#This is the list of hash keys
# "symbol"=>"YHOO"
# "Ask"=>"15.00"
# "AverageDailyVolume"=>"16537100"
# "Bid"=>"14.99"
# "AskRealtime"=>"15.00"
# "BidRealtime"=>"14.99"
# "BookValue"=>"10.445"
# "Change_PercentChange"=>"+0.01 - +0.07%"
# "Change"=>"+0.01"
# "Commission"=>nil
# "ChangeRealtime"=>"+0.01"
# "AfterHoursChangeRealtime"=>"N/A - N/A"
# "DividendShare"=>"0.00"
# "LastTradeDate"=>"8/17/2012"
# "TradeDate"=>nil
# "EarningsShare"=>"0.887"
# "ErrorIndicationreturnedforsymbolchangedinvalid"=>nil
# "EPSEstimateCurrentYear"=>"1.03"
# "EPSEstimateNextYear"=>"1.17"
# "EPSEstimateNextQuarter"=>"0.29"
# "DaysLow"=>"14.85"
# "DaysHigh"=>"15.04"
# "YearLow"=>"12.45"
# "YearHigh"=>"16.79"
# "HoldingsGainPercent"=>"- - -"
# "AnnualizedGain"=>nil
# "HoldingsGain"=>nil
# "HoldingsGainPercentRealtime"=>"N/A - N/A"
# "HoldingsGainRealtime"=>nil
# "MoreInfo"=>"cnsprmiIed"
# "OrderBookRealtime"=>nil
# "MarketCapitalization"=>"17.769B"
# "MarketCapRealtime"=>nil
# "EBITDA"=>"1.306B"
# "ChangeFromYearLow"=>"+2.55"
# "PercentChangeFromYearLow"=>"+20.48%"
# "LastTradeRealtimeWithTime"=>"N/A - <b>15.00</b>"
# "ChangePercentRealtime"=>"N/A - +0.07%"
# "ChangeFromYearHigh"=>"-1.79"
# "PercebtChangeFromYearHigh"=>"-10.66%"
# "LastTradeWithTime"=>"1:28pm - <b>15.00</b>"
# "LastTradePriceOnly"=>"15.00"
# "HighLimit"=>nil
# "LowLimit"=>nil
# "DaysRange"=>"14.85 - 15.04"
# "DaysRangeRealtime"=>"N/A - N/A"
# "FiftydayMovingAverage"=>"15.6957"
# "TwoHundreddayMovingAverage"=>"15.3811"
# "ChangeFromTwoHundreddayMovingAverage"=>"-0.3811"
# "PercentChangeFromTwoHundreddayMovingAverage"=>"-2.48%"
# "ChangeFromFiftydayMovingAverage"=>"-0.6957"
# "PercentChangeFromFiftydayMovingAverage"=>"-4.43%"
# "Name"=>"Yahoo! Inc."
# "Notes"=>nil
# "Open"=>"15.02"
# "PreviousClose"=>"14.99"
# "PricePaid"=>nil
# "ChangeinPercent"=>"+0.07%"
# "PriceSales"=>"3.57"
# "PriceBook"=>"1.44"
# "ExDividendDate"=>nil
# "PERatio"=>"16.90"
# "DividendPayDate"=>nil
# "PERatioRealtime"=>nil
# "PEGRatio"=>"1.18"
# "PriceEPSEstimateCurrentYear"=>"14.55"
# "PriceEPSEstimateNextYear"=>"12.81"
# "Symbol"=>"YHOO"
# "SharesOwned"=>nil
# "ShortRatio"=>"2.10"
# "LastTradeTime"=>"1:28pm"
# "TickerTrend"=>"&nbsp;-+-+-+&nbsp;"
# "OneyrTargetPrice"=>"17.89"
# "Volume"=>"13115221"
# "HoldingsValue"=>nil
# "HoldingsValueRealtime"=>nil
# "YearRange"=>"12.45 - 16.79"
# "DaysValueChange"=>"- - +0.07%"
# "DaysValueChangeRealtime"=>"N/A - N/A"
# "StockExchange"=>"NasdaqNM"
# "DividendYield"=>nil
# "PercentChange"=>"+0.07%"