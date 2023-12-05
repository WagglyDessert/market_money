class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all
  end

  def show
    # @market = MarketFacade.new(params[:market_id])

     # markets = Faraday.new(url: "http://localhost:3000")
    # response = markets.get("/api/v0/markets.json")
    # data = JSON.parse(response.body, symbolize_names: true)

    # members = data[:results][0][:members]

    # found_members = members.find_all {|m| m[:last_name] == params[:search]}
    # @member = found_members.first
    # render "welcome/index"
    begin
      market = Market.find(params[:id])
      render json: market
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
    end
  end
end