require 'rails_helper'

RSpec.describe "Vendor API Tests", type: :request do
  describe "All Vendors for a market API" do
    it "retrieves a list of vendors for a market" do
      market = create(:market)
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      market_vendor1 = create(:market_vendor, market_id: market.id, vendor_id: vendor_1.id)
      market_vendor2 = create(:market_vendor, market_id: market.id, vendor_id: vendor_2.id)
      get "/api/v0/markets/#{market.id}/vendors"
      expect(response).to be_successful

      vendors = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(vendors.count).to eq(2)
      
      vendors.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
      end
    end

    it "displays 404 error if it can't find market for vendors" do
      get "/api/v0/markets/322458/vendors"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to be_a(Array)
      expect(error[:errors].first[:status]).to eq("404")
      expect(error[:errors].first[:title]).to eq("Couldn't find Market with 'id'=322458")
    end

    it "retrieves information for a single vendor" do
      vendor_1 = create(:vendor)
      get "/api/v0/vendors/#{vendor_1.id}"
      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end

    it "displays 404 error if it can't find vendor" do
      get "/api/v0/vendors/1234"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to be_a(Array)
      expect(error[:errors].first[:status]).to eq("404")
      expect(error[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=1234")
    end
  end
end