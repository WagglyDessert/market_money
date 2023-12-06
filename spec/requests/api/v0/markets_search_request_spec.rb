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

    it "can find markets by state and city and name" do
      get '/api/v0/markets/search', params: {
        state: "IL",
        city: "Chicago",
        name: "A"
        }
      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(1)
      expect(markets[:data][0][:id].to_i).to eq(@market1.id)
    end

    it "can find markets by state and name" do
      get '/api/v0/markets/search', params: {
        state: "IL",
        name: "A"
        }
      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(1)
      expect(markets[:data][0][:id].to_i).to eq(@market1.id)
    end

    it "can find markets by name" do
      get '/api/v0/markets/search', params: {
        name: "A"
        }
      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(1)
      expect(markets[:data][0][:id].to_i).to eq(@market1.id)
    end

    it "returns a 422 message if invalid parameters are sent in" do
      get '/api/v0/markets/search', params: {
        city: "Chicago",
        name: "A"
        }
      expect(response).to_not be_successful

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      r = JSON.parse(response.body, symbolize_names: true)
      expect(r[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    it "returns a 422 message if invalid parameters are sent in" do
      get '/api/v0/markets/search', params: {
        city: "Chicago"
        }
      expect(response).to_not be_successful

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      r = JSON.parse(response.body, symbolize_names: true)
      expect(r[:errors].first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    it "if proper params are sent in but no markets are found, return empty array" do
      get '/api/v0/markets/search', params: {
        name: "H"
        }
      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(0)
      expect(markets[:data]).to eq([])
    end

  end
end
