require_relative 'app/scraper.rb'
require 'json'

task :scrape_for_tickets do
  scraper = Scraper.new
  events = scraper.scrape_events
  puts JSON.generate(events)
end
