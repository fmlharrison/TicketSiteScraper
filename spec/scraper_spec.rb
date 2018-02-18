require 'spec_helper'
require 'httparty'
require_relative '../app/scraper'

RSpec.describe Scraper do
  include HTTParty

  let(:subject) { described_class.new }

  describe '#event_links' do
    it 'should return a list of event page links' do
      VCR.use_cassette('wegottickets/allevents') do
        page = HTTParty.get(Scraper::BASE_URL)
        subject.event_links(page)
        expect(subject.events.length).to eq(10)
      end
    end
  end
end
