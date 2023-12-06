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

    begin
      vendor.save!
      render json: VendorSerializer.new(vendor)
    rescue ActiveRecord::RecordInvalid => e
      error_messages = e.record.errors.full_messages.join(', ')
      render json: { errors: [{ status: "400", detail: "Validation failed: #{error_messages}" }] }, status: :bad_request
    end
  end

  def update
    vendor = Vendor.find(params[:id])
    # begin
    #   vendor.update(vendor_params)
    #   render json: VendorSerializer.new(vendor)
    # rescue ActiveRecord::RecordInvalid => e
    #   error_messages = e.record.errors.full_messages.join(', ')
    #   render json: { errors: [{ status: "400", detail: "Validation failed: #{error_messages}" }] }, status: :bad_request
    if vendor.update(vendor_params)
      render json: VendorSerializer.new(vendor)
    else
      error_messages = vendor.errors.full_messages.join(', ')
      render json: { errors: [{ status: "400", detail: "Validation failed: #{error_messages}" }] }, status: :bad_request
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

end