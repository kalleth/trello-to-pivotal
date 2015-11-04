#!/usr/bin/env ruby

if ENV['TRELLO_API_KEY'].nil? || ENV['TRELLO_TOKEN'].nil?
  STDERR.puts "You must provide TRELLO_API_KEY and TRELLO_TOKEN as environment variables."
  STDERR.puts "See the documentation for `ruby-trello` to obtain these."
  exit 1
end

require 'trello'
require 'csv'

Trello.configure do |config|
  config.developer_public_key = ENV['TRELLO_API_KEY']
  config.member_token = ENV['TRELLO_TOKEN']
end

LIST_REGEX = /Sprint \+1/

board = Trello::Board.find(ENV['TRELLO_BOARD'])
list = board.lists.select { |list| list.name =~ LIST_REGEX }.first

csv_data = CSV.generate do |csv|
  csv << %w(Title Type Description)
  list.cards.each do |card|
    csv << [card.name, 'feature', card.desc + "\n\nImported from: #{card.url}"]
  end
end

puts csv_data
