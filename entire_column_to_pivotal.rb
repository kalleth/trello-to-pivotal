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
ESTIMATE_REGEX = /\((\d)\)/

board = Trello::Board.find(ENV['TRELLO_BOARD'])
list = board.lists.select { |list| list.name =~ LIST_REGEX }.first

full_export = []
max_tasks = 0

list.cards.each do |card|
  next unless card.labels.map(&:name).include?("Ready for Planning")

  title = card.name
  matches = title.match(ESTIMATE_REGEX)
  estimate = matches.present? ? matches[1] : nil

  output = [title, 'feature', card.desc + "\n\nImported from: #{card.url}", estimate]

  # only support the first checklist for now
  if card.checklists.any?
    list = card.checklists.first
    items = list.check_items

    max_tasks = items.size if items.size > max_tasks
    items.each do |item|
      # translate back to raw from markdown?
      output << item["name"]
    end
  end

  # warn because i can't import attachments
  if card.attachments.any?
    STDERR.puts "This card has attachments! Please import them manually from #{card.url}"
  end

  full_export << output
end

headings = %w(Title Type Description Estimate)
headings = headings + max_tasks.times.map { "Task" }

csv_data = CSV.generate do |csv|
  csv << headings
  full_export.each { |line| csv << line }
end

puts csv_data
