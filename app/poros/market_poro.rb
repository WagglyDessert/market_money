class MarketData
  attr_reader :id,
              :name,
              :street,
              :city,
              :county,
              :state,
              :zip,
              :lat,
              :lon
  def initialize(data)
    @id = data[:details][:id]
    @title = data[:details][:title]
    @runtime = data[:details][:runtime]
    @vote_average = data[:details][:vote_average]
    @genre = genres(data[:details])
    @summary = data[:details][:overview]
    @credits = credits_maker(data[:credits])
    @reviews = reviews_maker(data[:reviews])
    @review_count = @reviews.count
  end
end