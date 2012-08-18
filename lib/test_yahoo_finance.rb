require './yahoo_finance'

portfolio = ["AAPL", "MSFT"]

data = YahooFinance.quotes(portfolio, [:ask, :bid, :change_and_percent_change, :pe_ratio])

puts data

history = YahooFinance.historical_quotes("BVSP", Time::now-(24*60*60*365), Time::now, { :raw => false, :period => :monthly })

puts history