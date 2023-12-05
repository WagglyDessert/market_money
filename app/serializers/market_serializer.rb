class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon

  has_many :vendors

  attribute :vendor_count do |object|
    object.vendors.count
  end

  attribute :active do
    true
  end
end
