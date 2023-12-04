class Api::V0::MarketsController < ApplicationController
  def index
    # markets = Faraday.new(url: "http://localhost:3000")
    # response = markets.get("/api/v0/markets.json")
    # data = JSON.parse(response.body, symbolize_names: true)

    # members = data[:results][0][:members]

    # found_members = members.find_all {|m| m[:last_name] == params[:search]}
    # @member = found_members.first
    # render "welcome/index"

    render json: Market.all
  end

  def show
    @market = MarketFacade.new(params[:market_id])
    render json: @market
  end
end