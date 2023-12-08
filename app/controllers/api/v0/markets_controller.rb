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

  def cash
    market = Market.find(params[:market_id])
    # @facade = ATMFacade.new(market.lat, market.lon)
    # render json: ATMSerializer.new(ATMFacade.atms(market))
    
    #this is a test for without refactor to facade/poro/service
    lat = market.lat.to_f 
    lon = market.lon.to_f
    
    tom_tom_url(lat, lon)

    
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

  def tom_tom_url(lat, lon)
    response = Faraday.get("https://api.tomtom.com/search/2/search/atms.json?key=#{Rails.application.credentials.tomtom[:key]}&lat=#{lat}&lon=#{lon}")

    json = JSON.parse(response.body, symbolize_names: true)

    atms = json[:results].map do |atm_data|
      {
        id: nil,
        type: "atm",
        attributes: {
          name: atm_data[:poi][:name],
          address: format_address(atm_data[:address]),
          lat: atm_data[:position][:lat],
          lon: atm_data[:position][:lon],
          distance: atm_data[:dist]
        }
      }
    end

    #the controller isn't finding these methods in the model for some reason
    atms_array_closest_to_furthest = atms.sort_by { |atm| atm[:attributes][:distance] }

    @atms = { data: atms_array_closest_to_furthest }

    render json: @atms
  end

  #the controller isn't finding these methods in the model for some reason
  def format_address(param)
    street_number = param[:streetNumber]
    street_name = param[:streetName]
    city = param[:municipality]
    state = param[:countrySubdivision]
    postal_code = param[:postalCode]

    [street_number, street_name, city, state, postal_code].compact.join(', ')
  end

end
