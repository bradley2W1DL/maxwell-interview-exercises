#!/bin/env/ruby

# Main file to run...
# needs to load up all the models
require "./models/item" # load parent class first
# load up all subclasses
Dir["./models/*.rb"].each { |file| require file }

puts "What did you buy today?"
puts "Input your full list, delimited by commas:"

input = gets()
