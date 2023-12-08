class ATMService 
  def nearby_atms(lat, lon)
    conn = Faraday.new(url: "https://api.tomtom.com/search/2/search/atms.json?key={mykey}") do |faraday|
      faraday.headers["X-API-Key"] = Rails.application.credentials.tomtom[:key]
    end

    response = conn.get("&lat=#{lat}&lon=#{lon}&radius=10000")

    JSON.parse(response.body, symbolize_names: true)
  end
end