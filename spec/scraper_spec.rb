require 'mechanize'
require_relative '../app/scraper'

RSpec.describe Scraper do
  let(:subject) { described_class.new }

  before(:all) do
    VCR.use_cassette('wegottickets/music') do
      events_page = Mechanize.new.get("http://www.wegottickets.com/searchresults")
      @events = events_page.search('div.content.block-group.chatterbox-margin')
    end
  end

  describe '#all_events' do
    it 'return a list of 10 events that are on the page' do
      expect(subject.all_events(@events).length).to eq(10)
    end
  end

  describe '#event_info' do
    it 'should return the info of an event' do
      event_info = subject.event_info(@events.first)
      expect(event_info['artist']).to eq('MARCO MENDOZA VIVA LA ROCK TOUR 2018')
      expect(event_info['city']).to eq('CHESTERFIELD')
      expect(event_info['venue']).to eq('Real Time Live')
      expect(event_info['date'].to_s).to eq DateTime.parse('Sun 20th Feb, 2018, 19:30pm').to_s
      expect(event_info['pricing']).to include('price' => '£13.20')
    end
  end

  describe '#event_pricing' do
    it 'should return the pricing info of an event' do
      expected_pricing = {
        'price' => '£11.00',
        'ticket_count' => '49 tickets available'
      }

      event_pricing = subject.event_pricing(@events.last)
      expect(event_pricing).to include(expected_pricing)
    end

    it 'should return pricing with a concession' do
      event_pricing = subject.event_pricing(@events[6])
      expect(event_pricing).to include('concession' => 'Under 18')
    end
  end

  describe '#scrape_events' do
    before(:each) do
      @scraper = described_class.new(2)
    end

    it 'should make a array of all the event details on the page' do
      VCR.use_cassette('wegottickets/allevents') do
        VCR.use_cassette('wegottickets/music') do
          VCR.use_cassette('wegottickets/musicpage2') do
            events = @scraper.scrape_events
            expect(events).to be_an_instance_of(Array)
            expect(events.length).to eq(20)
          end
        end
      end
    end
  end
end
