class MovieFacade
  attr_reader :market
  def initialize(market_id)
    @market_id = market_id
    @market = market_maker
  end

  def market_maker
    market = MarketService.new
    
    json = service.all_markets(@market_id)
    
    MarketData.new(json)
  end
end