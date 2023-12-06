require 'rails_helper'

RSpec.describe "Search Market API Tests", type: :request do
  before(:each) do 
    @market1 = Market.create(name: "A", street: "A", city: "Chicago", county: "A", state: "IL", zip: "10101", lat: "1234567", lon: "1234567")
    @market2 = Market.create(name: "B", street: "A", city: "Chicago", county: "A", state: "IL", zip: "10101", lat: "1234567", lon: "1234567")
    @market3 = Market.create(name: "C", street: "A", city: "Evanston", county: "A", state: "IL", zip: "10101", lat: "1234567", lon: "1234567")
    @market4 = Market.create(name: "D", street: "A", city: "Denver", county: "A", state: "CO", zip: "10101", lat: "1234567", lon: "1234567")
    @market5 = Market.create(name: "E", street: "A", city: "Denver", county: "A", state: "CO", zip: "10101", lat: "1234567", lon: "1234567")
    @market6 = Market.create(name: "F", street: "A", city: "Vail", county: "A", state: "CO", zip: "10101", lat: "1234567", lon: "1234567")
    @market7 = Market.create(name: "G", street: "A", city: "Vail", county: "A", state: "CO", zip: "10101", lat: "1234567", lon: "1234567")
  end
  describe "Search Markets API" do
    it "can find markets by state" do
      get '/api/v0/markets/search', params: {
        state: "IL"
        }
      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(3)
      expect(markets[:data][0][:id].to_i).to eq(@market1.id)
      expect(markets[:data][1][:id].to_i).to eq(@market2.id)
      expect(markets[:data][2][:id].to_i).to eq(@market3.id)
    end

    it "can find markets by state and city" do
      get '/api/v0/markets/search', params: {
        state: "IL",
        city: "Chicago"
        }
      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(2)
      expect(markets[:data][0][:id].to_i).to eq(@market1.id)
      expect(markets[:data][1][:id].to_i).to eq(@market2.id)
    end
  end
end
