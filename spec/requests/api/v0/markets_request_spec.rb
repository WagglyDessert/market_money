require 'rails_helper'

RSpec.describe "Market API Tests", type: :request do
  describe "All Markets API" do
    it "sends a list of all markets" do
      create_list(:market, 3)
      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(markets.count).to eq(3)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)

        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_a(String)

        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_a(String)

        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_a(String)

        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_a(String)

        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_an(String)

        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_an(String)

        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_an(String)

        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_an(String)
      end
    end

    it "gets one market" do
      id = create(:market).id
      get "/api/v0/markets/#{id}"
      expect(response).to be_successful
      market = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(String)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_an(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_an(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_an(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_an(String)
    end

    it "displays 404 error if it can't find market" do
      get "/api/v0/markets/322458"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to be_a(Array)
      expect(error[:errors].first[:status]).to eq("404")
      expect(error[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=322458")
    end

    it "retrieves a list of nearby atms" do
      market = create(:market)
      get "/api/v0/markets/#{market.id}/nearest_atms"

      expect(response).to be_successful
      expect(response.status).to eq(200)
      atms = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(atms.first).to have_key(:id)
      expect(atms.first[:id]).to eq(nil)
      expect(atms.first).to have_key(:type)
      expect(atms.first).to have_key(:attributes)
      expect(atms.first[:attributes]).to have_key(:name)
      expect(atms.first[:attributes]).to have_key(:address)
      expect(atms.first[:attributes]).to have_key(:lat)
      expect(atms.first[:attributes]).to have_key(:lon)
      expect(atms.first[:attributes]).to have_key(:distance)

      expect(atms.first[:attributes][:distance]).to be < (atms.second[:attributes][:distance])
      expect(atms.index(atms.first)).to be < atms.index(atms.second)
    end

    it "returns status 404 if market id is incorrect" do
      get "/api/v0/markets/1234/nearest_atms"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to be_a(Array)
      expect(error[:errors].first[:status]).to eq("404")
      expect(error[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=1234")
    end

  end
end