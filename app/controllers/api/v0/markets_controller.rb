class Api::V0::MarketsController < ApplicationController
  def index
    render json: Market.all
  end

  def show
    begin
      market = Market.find(params[:id])
      render json: market
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
    end
  end
end