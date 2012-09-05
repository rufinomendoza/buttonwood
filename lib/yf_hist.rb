require 'open-uri'
require 'ostruct'
require 'csv'

  def read_historical(symbol, start_date, end_date, options)
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
     # got this from https://github.com/herval/yahoo-finance/blob/master/lib/yahoo_finance.rb
  end

foo = read_historical("AAPL", Time::now-(24*60*60*365), Time::now,{ :period => "d" })[:adjusted_close]
puts foo.first
puts foo.last