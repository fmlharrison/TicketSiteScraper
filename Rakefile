require_relative 'app/scraper.rb'
require 'json'

task :scrape_for_tickets, [:pages] do |_, args|
  number_of_pages = args[:pages].to_i
  scraper = Scraper.new(number_of_pages)
  events = scraper.scrape_events
  puts JSON.generate(events)
end
