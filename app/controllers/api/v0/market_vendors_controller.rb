class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def new
  end
  
  def create
    market_vendor = MarketVendor.new(market_vendor_params)
    if market_vendor.save
      render json: {
        market_vendor: MarketVendorSerializer.new(market_vendor),
        message: "Successfully added vendor to market"
      }, status: :created
    else
      market_vendor_rescue_options(market_vendor)
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if market_vendor
      market_vendor.destroy
      head :no_content
    else
      render json: { errors: [{ status: "404", detail: "No MarketVendor with market_id=#{params[:market_id].to_i} AND vendor_id=#{params[:vendor_id].to_i} exists" }] }, status: :not_found
    end
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def market_vendor_rescue_options(market_vendor)
    if (Vendor.exists?(market_vendor.vendor_id) && Market.exists?(market_vendor.market_id)) == false
      if market_vendor.vendor_id == nil || market_vendor.market_id == nil
        error_messages = market_vendor.errors.full_messages.join(', ')
        render json: { errors: [{ status: "400", detail: "Validation failed: #{error_messages}" }] }, status: :bad_request 
      else 
        error_messages = market_vendor.errors.full_messages.join(', ')
        render json: { errors: [{ status: "404", detail: "Validation failed: #{error_messages}" }] }, status: :not_found 
      end
    else
      error_messages = market_vendor.errors.full_messages.join(', ')
        render json: { errors: [{ status: "422", detail: "Validation failed: #{error_messages}" }] }, status: :unprocessable_entity
    end
  end

end