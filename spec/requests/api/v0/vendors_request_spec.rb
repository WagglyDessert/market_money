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
      expect(error[:errors].first[:detail]).to eq("Couldn't find Market with 'id'=322458")
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
      expect(error[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=1234")
    end

    it "creates a vendor" do
      post "/api/v0/vendors", params: {
      name: "Buzzy Bees",
      description: "local honey and wax products",
      contact_name: "Berly Couwer",
      contact_phone: "8389928383",
      credit_accepted: false
      }
      expect(response).to be_successful
      vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)
    end

    it "has error message for creating a vendor improperly" do
      post "/api/v0/vendors", params: {
      name: "Buzzy Bees",
      description: "local honey and wax products",
      credit_accepted: false
      }
      expect(response.status).to eq(400)
      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error).to have_key(:errors)
      expect(error[:errors].first[:detail]).to be_a(String)
    end

    it "updates a vendor" do
      post "/api/v0/vendors", params: {
      name: "Buzzy Bees",
      description: "local honey and wax products",
      contact_name: "Berly Couwer",
      contact_phone: "8389928383",
      credit_accepted: false
      }

      expect(response).to be_successful
      vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(vendor).to have_key(:id)
      patch "/api/v0/vendors/#{vendor[:id].to_i}", params: {
        "contact_name": "Kimberly Couwer",
        "credit_accepted": false
      }
      expect(response).to be_successful
      updated_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(updated_vendor).to have_key(:id)
      expect(updated_vendor[:id]).to be_a(String)

      expect(updated_vendor[:attributes]).to have_key(:name)
      expect(updated_vendor[:attributes][:name]).to eq("Buzzy Bees")

      expect(updated_vendor[:attributes]).to have_key(:description)
      expect(updated_vendor[:attributes][:description]).to eq("local honey and wax products")

      expect(updated_vendor[:attributes]).to have_key(:contact_name)
      expect(updated_vendor[:attributes][:contact_name]).to eq("Kimberly Couwer")

      expect(updated_vendor[:attributes]).to have_key(:contact_phone)
      expect(updated_vendor[:attributes][:contact_phone]).to eq("8389928383")

      expect(updated_vendor[:attributes]).to have_key(:credit_accepted)
      expect(updated_vendor[:attributes][:credit_accepted]).to eq(false)

      expect(vendor[:id]).to eq(updated_vendor[:id])
    end

    it "displays 404 error if it can't find vendor to update" do
      patch "/api/v0/vendors/1234", params: {
        "contact_name": "Kimberly Couwer",
        "credit_accepted": false
      }
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to be_a(Array)
      expect(error[:errors].first[:status]).to eq("404")
      expect(error[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=1234")
    end

    it "displays 400 error if vendor exists but params are not validated" do
      post "/api/v0/vendors", params: {
      name: "Buzzy Bees",
      description: "local honey and wax products",
      contact_name: "Berly Couwer",
      contact_phone: "8389928383",
      credit_accepted: false
      }

      expect(response).to be_successful
      vendor = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(vendor).to have_key(:id)

      patch "/api/v0/vendors/#{vendor[:id].to_i}", params: {
        "contact_name": "",
        "credit_accepted": false
      }
      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error).to have_key(:errors)
      expect(error[:errors].first[:detail]).to be_a(String)
    end

    it "deletes a vendor" do
      post "/api/v0/vendors", params: {
      name: "Buzzy Bees",
      description: "local honey and wax products",
      contact_name: "Berly Couwer",
      contact_phone: "8389928383",
      credit_accepted: false
      }

      vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      delete "/api/v0/vendors/#{vendor[:id].to_i}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(response.body).to eq("")
    end

    it "404 error when trying to delete a non-existent vendor" do
      delete "/api/v0/vendors/1234"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors]).to be_a(Array)
      expect(error[:errors].first[:status]).to eq("404")
      expect(error[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=1234")
    end
  end
end