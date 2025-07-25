require 'rails_helper'

RSpec.describe SearchQueriesHelper, type: :helper do
  describe 'all_trending_queries' do
    it 'return the first 3 terms in desc order' do
      SearchQuery.create!(term: "term1", ip_address: '127.0.0.1')
      SearchQuery.create!(term: "term1", ip_address: '127.0.0.1')
      SearchQuery.create!(term: "term1", ip_address: '127.0.0.1')
      SearchQuery.create!(term: "term2", ip_address: '127.0.0.1')
      SearchQuery.create!(term: "term2", ip_address: '127.0.0.1')
      SearchQuery.create!(term: "term3", ip_address: '127.0.0.1')
      
      result = helper.all_trending_queries

      expect(result.keys.size).to eq(3)
      expect(result.keys.first).to eq('term1')
    end
  end

  describe 'format_trend_information' do
    it 'format the info' do
      trend = ['Fortnite', 10]
      expect(helper.format_trend_information(trend)).to eq('Fortnite (10 hits)')
    end

    it 'return nil if empty' do
      expect(helper.format_trend_information(nil)).to be_nil
      expect(helper.format_trend_information([])).to be_nil
    end
  end

  describe 'format_analytics_information' do
    it 'format the analytic info' do
      analytic = SearchQuery.new(term: 'Fortnite', ip_address: '192.168.0.1')
      expect(helper.format_analytics_information(analytic)).to eq('Term: Fortnite | (From 192.168.0.1)')
    end

    it 'return nil if empty' do
      expect(helper.format_analytics_information(nil)).to be_nil
    end
  end

  describe 'format_top_ten_information' do
    it 'format the top ten info' do
      analytic = ['Minecraft', 20]
      expect(helper.format_top_ten_information(analytic)).to eq('Term: Minecraft (20 hits)')
    end

    it 'return nil if empty' do
      expect(helper.format_top_ten_information(nil)).to be_nil
    end
  end
end