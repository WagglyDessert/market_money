require 'rails_helper'

RSpec.describe "MarketVendor API Tests", type: :request do
  describe "All MarketVendors for a market API" do
    it "creates a vendor" do
      market = create(:market)
      vendor = create(:vendor)
      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "#{vendor.id}",
      }
      expect(response).to be_successful
      expect(response.status).to eq(201)
      mv = JSON.parse(response.body, symbolize_names: true)[:market_vendor][:data]
      
      expect(mv).to have_key(:id)
      expect(mv[:id]).to be_a(String)

      expect(mv[:attributes][:market_id]).to eq(market.id)
      expect(mv[:attributes][:vendor_id]).to eq(vendor.id)

      rb = mv = JSON.parse(response.body, symbolize_names: true)
      expect(rb[:message]).to eq("Successfully added vendor to market")
    end

    it "has 404 error message for creating a market_vendor improperly if using invalid id" do
      market = create(:market)
      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "1234",
      }
      expect(response.status).to eq(404)
      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error).to have_key(:errors)
      expect(error[:errors].first[:detail]).to be_a(String)
    end

    it "has 400 error message for creating a market_vendor improperly if not passing in an id" do
      market = create(:market)
      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "",
      }
      expect(response.status).to eq(400)
      error = JSON.parse(response.body, symbolize_names: true)
    
      expect(error).to have_key(:errors)
      expect(error[:errors].first[:detail]).to be_a(String)
    end

    it "has 422 error when trying to create a marketvendor between market and vendor that already exists" do
      market = create(:market)
      vendor = create(:vendor)
      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "#{vendor.id}",
      }
      expect(response).to be_successful
      expect(response.status).to eq(201)

      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "#{vendor.id}",
      }
      expect(response.status).to eq(422)
      error = JSON.parse(response.body, symbolize_names: true)
    
      expect(error).to have_key(:errors)
      expect(error[:errors].first[:detail]).to be_a(String)
    end

    it "deletes a marketvendor" do
      market = create(:market)
      vendor = create(:vendor)
      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "#{vendor.id}",
      }
      expect(response).to be_successful
      expect(response.status).to eq(201)
      mv = JSON.parse(response.body, symbolize_names: true)[:market_vendor][:data]
      delete "/api/v0/market_vendors", params: {
        market_id: market.id,
        vendor_id: vendor.id,
      }

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
    end

    it "returns a 404 error if it cannot delete a marketvendor" do
      market = create(:market)
      vendor = create(:vendor)
      post "/api/v0/market_vendors", params: {
      market_id: "#{market.id}",
      vendor_id: "#{vendor.id}",
      }
      expect(response).to be_successful
      expect(response.status).to eq(201)
      mv = JSON.parse(response.body, symbolize_names: true)[:market_vendor][:data]
      delete "/api/v0/market_vendors", params: {
        market_id: market.id,
        vendor_id: 1234,
      }
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      expect(response.body).to eq("{\"errors\":[{\"status\":\"404\",\"detail\":\"No MarketVendor with market_id=#{market.id} AND vendor_id=1234 exists\"}]}")
    end
  end
end