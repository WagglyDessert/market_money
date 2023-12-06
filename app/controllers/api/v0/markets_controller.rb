class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    render json: MarketSerializer.new(Market.find(params[:id]))
  end

  def search
    state = params[:state]
    city = params[:city]
    name = params[:name]

    validate_parameters(state, city, name)
    
  end

  private
 
  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def validate_parameters(state, city, name)
    if city.present? && name.nil? && state.nil?
      invalid_combinations = true
    elsif city.present? && name.present? && state.nil?
      invalid_combinations = true
    else 
      invalid_combinations = false
    end   

    if invalid_combinations == true
      render json: { errors: [{ status: "422", detail: "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint." }] }, status: :unprocessable_entity
    else
      markets = market_search(state, city, name)
      render json: MarketSerializer.new(markets)
    end
  end

  def market_search(state, city, name)
    if state.present? && city.present? && name.present?
      markets = Market.where(state: state, city: city, name: name)
    elsif state.present? && city.present?
      markets = Market.where(state: state, city: city)
    elsif state.present? && name.present?
      markets = Market.where(name: name, state: state)
    elsif state.present?
      markets = Market.where(state: state)
    else
      markets = Market.where(name: name)
    end
    markets
  end

end
