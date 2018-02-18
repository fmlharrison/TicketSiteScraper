require 'mechanize'
require_relative '../app/scraper'

RSpec.describe Scraper do
  let(:subject) { described_class.new }

  before(:all) do
    VCR.use_cassette('wegottickets/allevents') do
      events_page = Mechanize.new.get(Scraper::BASE_URL)
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
      expect(event_info['artist']).to eq('ABSOLUTE & ALMOST BEGINNERS COMEDY COURSE :: STARTS ON SUNDAY 18 FEBRUARY AT NOON (#13A)')
      expect(event_info['city']).to eq('LONDON')
      expect(event_info['venue']).to eq("The Albany's Comedy Cellar")
      expect(event_info['date'].to_s).to eq DateTime.parse('Sun 18th Feb, 2018, 12:00pm').to_s
      expect(event_info['pricing']).to include('price' => '£582.00')
    end
  end

  describe '#event_pricing' do
    it 'should return the pricing info of an event' do
      expected_pricing = {
        'price' => '£6.60',
        'ticket_count' => '10 tickets available',
        'concession' => 'Unwaged - You may be asked to provide eligibility proof at the venue',
        'warning' => ''
      }

      event_pricing = subject.event_pricing(@events.last)
      expect(event_pricing).to eq(expected_pricing)
    end
  end

  describe '#scrape_events' do
    it 'should make a array of all the event details on the page' do
      VCR.use_cassette('wegottickets/allevents') do
        VCR.use_cassette('wegottickets/music') do
          events = subject.scrape_events
          expect(events).to be_an_instance_of(Array)
          expect(events.length).to eq(10)
        end
      end
    end
  end
end
