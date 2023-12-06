class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    market = Market.find(params[:market_id])
    vendors = market.vendors
    render json: VendorSerializer.new(vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def new
  end

  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: VendorSerializer.new(vendor)
    else
      rescue_from ActiveRecord::RecordNotFound, with: :not_created_response
    end
  end

  private

  def vendor_params
    params.permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def not_created_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
      .serialize_json, status: :not_found
  end
end