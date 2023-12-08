class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  ##FOR SOME REASON THE CONTROLLER ISN'T ACCESSING THESE METHODS????!?!??##
  
  # def atm_by_distance(atms)
  #   atms.sort_by { |atm| atm[:distance] }
  # end

  # def format_address(param)
  #   street_number = param[:streetNumber]
  #   street_name = param[:streetName]
  #   city = param[:municipality]
  #   state = param[:countrySubdivision]
  #   postal_code = param[:postalCode]

  #   [street_number, street_name, city, state, postal_code].compact.join(', ')
  # end

end