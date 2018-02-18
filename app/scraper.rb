require 'nokogiri'
require 'httparty'

class Scraper
  BASE_URL = 'http://www.wegottickets.com/searchresults/all'.freeze

  attr_reader :events_page, :events

  def initialize(events = [])
    @events = events
  end

  def event_links(event_page)
    parse_page = Nokogiri::HTML(event_page)
    parse_page.css('a.event_link').each do |link|
      event_link = link.attributes['href'].value
      events.push(event_link)
    end
  end
end
