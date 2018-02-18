require 'nokogiri'
require 'mechanize'
require 'httparty'
require 'pry'

class Scraper
  BASE_URL = 'http://www.wegottickets.com/searchresults/all'.freeze

  attr_reader :events_list_page, :pages_count, :events

  def initialize(pages_count = 1)
    @pages_count = pages_count
    @events = []
  end

  def scrape_events
    web_page_details
    count = 0
    while count < pages_count
      events_on_page(events_list_page)
      count += 1
      break if count == pages_count
      next_page(events_list_page)
    end
    events.flatten
  end

  def events_on_page(page)
    events_on_page = all_events(page).map do |event|
      event_info(event)
    end
    events << events_on_page
  end

  def all_events(tickets_page)
    tickets_page.search('div.content.block-group.chatterbox-margin')
  end

  def event_info(event)
    event_info = {}
    venue = event.search('div.venue-details h4').first.text.split(':')
    event_info['artist'] = event.search('a.event_link').text
    event_info['city'] = venue.first.strip
    event_info['venue'] = venue.last.strip
    event_info['date'] = DateTime.parse(event.search('div.venue-details h4')[1].text.to_s)
    event_info['pricing'] = event_pricing(event.search('div.block.diptych.text-right'))

    event_info
  end

  def event_pricing(pricing_element)
    event_pricing = {}
    event_pricing['price'] = pricing_element.search('div.searchResultsPrice strong').text
    event_pricing['ticket_count'] = pricing_element.search('div.buy-stock div').text
    event_pricing['concession'] = pricing_element.search('span.concession').text
    event_pricing['warning'] = pricing_element.search('span.warning').text

    event_pricing
  end

  private

  def web_page_details
    agent = Mechanize.new
    page = agent.get(BASE_URL)
    search_form = page.form_with(id: 'search-form')
    search_form.field_with(class: 'search-form').value = 'music'
    @events_list_page = search_form.submit
  end

  def next_page(page)
    @events_list_page = page.link_with(class: 'pagination_link_text nextlink').click
  end
end
