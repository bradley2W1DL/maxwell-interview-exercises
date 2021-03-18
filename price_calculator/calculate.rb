#!/bin/env/ruby

# Main file to run...
# needs to load up all the models
require "./models/item" # load parent class first
# load up all subclasses
Dir["./models/*.rb"].each { |file| require file }

puts "Hello, what did you purchase today?"
puts "please list out all your items in a comma-delimited list"
# # #
# Prompt user for input and parse into an array of strings, eliminating empty elements
list = gets.split(',').map(&:strip).reject(&:empty?)

if list.length == 0
  abort("It looks like you didn't buy anthing today")
end

# # #
# sort the input to get quantities
sorted_hash = list.inject({}) do |hash, item|
  key = item.downcase.to_sym
  hash[key] = hash.keys.include?(key) ? hash[key] + 1 : 1
  hash
end

objects = sorted_hash.map do |item, quantity|
  begin
    Object.const_get(item.capitalize).new(quantity)
  rescue NameError => e
    puts "item #{item} not recognized, skipping..." # maybe only if debug flag
  end
end
total_price = objects.reduce(0) { |sum, item| sum += item.total_non_sale_cost }
savings = objects.reduce(0) { |sum, item| sum += item.total_savings }

puts ''
puts "Item    Quantity  Price   "
puts "--------------------------"
objects.each do |item|
  puts item.formatted_item_string
end
puts ''
puts "Total price : $#{total_price}"
puts "You saved $#{savings} today."
puts ''
