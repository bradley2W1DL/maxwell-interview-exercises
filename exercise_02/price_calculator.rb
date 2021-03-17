#!/bin/env/ruby
require "./price_list.rb"
# execute as: `ruby price_calculator.rb`
# prompt user for food list
puts "Hello, what did you purchase today?"
puts "please list out all your items in a comma-delimited list"
# clean up user input into an array of strings, eliminating empty elements
list = gets.split(',').map(&:strip).reject(&:empty?)

if list.length == 0
  abort("It looks like you didn't buy anthing today")
end

# sort the input
sorted_hash = list.inject({}) do |hash, item|
  key = item.downcase.to_sym
  hash[key] = hash.keys.include?(key) ? hash[key] + 1 : 1
  hash
end
#puts sorted_hash
non_sale_price = sorted_hash.inject(0) do |sum, (item, quantity)|
  sum += PRICE_LIST[item.to_sym][:price] * quantity rescue 0 # rescue for unrecognized "items"
end
#puts "full price: $#{non_sale_price}"

final_result = sorted_hash.inject({}) do |result, (item, quantity)|
  total_price = 0
  price_hash = PRICE_LIST[item]
  next unless price_hash # skip unrecognized items

  if price_hash.keys.include? :sale
    # this item has some kind of bogo pricing.
    sale_items = quantity / price_hash[:sale][:quantity]
    total_price += sale_items * price_hash[:sale][:price]
    # remainder of items are full price:
    total_price += (quantity % price_hash[:sale][:quantity]) * price_hash[:price]
  else
    total_price += quantity * price_hash[:price]
  end
  result[item] = {quantity: quantity, total_price: total_price}
  result
end

#puts final_result

col_widths = [8,10,8]
# simple function to add padding to string for output formatting.
right_pad = ->(string, col_width) {
  string + ' ' * (col_width - string.length)
}
item_rows = final_result.map do |item, result|
  [item.to_s, result[:quantity].to_s, "$#{result[:total_price].round(2)}"]
end
# #
# Format the output:
puts ''
puts "Item    Quantity  Price   "
puts "--------------------------"
item_rows.each do |row|
  item, quantity, price = row
  puts right_pad.call(item, col_widths[0]) + right_pad.call(quantity, col_widths[1]) + right_pad.call(price, col_widths[2])
end
puts ''
total_price = final_result.values.reduce(0) { |sum, hash| sum += hash[:total_price] }
savings = (non_sale_price - total_price).round(2)
puts "Total price : $#{total_price}"
puts "You saved $#{savings} today."
