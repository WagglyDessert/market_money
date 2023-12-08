class ATMFacade
  def initialize(lat, lon)
    @lat = market.lat 
    @lon = market.lon
  end

  def atms
    service = ATMService.new 

    json = service.nearby_atms(@lat, @lon)

    @atms = json[:results].map do |atm_data|
      ATM.new(atm_data)
    end
  end
end