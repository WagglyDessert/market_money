require 'rails_helper'

RSpec.describe "Market API Tests", type: :request do
  describe "All Markets API" do
    it "sends a list of all markets" do
      create_list(:market, 3)
      get '/api/v0/markets'

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)

      expect(markets.count).to eq(3)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(Integer)

        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)

        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)

        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)

        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)

        expect(market).to have_key(:state)
        expect(market[:state]).to be_an(String)

        expect(market).to have_key(:zip)
        expect(market[:zip]).to be_an(String)

        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_an(String)

        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_an(String)
      end
    end

    it "gets one market" do
      id = create(:market).id
      get "/api/v0/markets/#{id}"
      expect(response).to be_successful
      market = JSON.parse(response.body, symbolize_names: true)
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_an(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_an(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_an(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_an(String)
    end

    it "displays 404 error if it can't find market" do
      get "/api/v0/markets/322458"
      expect(response).to_not be_successful
      error = JSON.parse(response.body, symbolize_names: true)
      expect(error[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=322458")
    end

  end
end