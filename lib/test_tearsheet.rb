require './tearsheet'



portfolio = ["AAPL","YHOO"]

keys=["Symbol","PercentChange"]

puts keys.inspect

portfolio.each do |ticker|
  array = []
  keys.each do |key|
    array << Tearsheet.lambda(key, ticker)
  end
  puts array.inspect
end