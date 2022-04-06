class Territory < ApplicationRecord
  include Lookup

  has_many :emissions

  enum territory_type: {
    country: 0,
    state: 1,
    non_allocated: 2,
    bunker: 3,
    city: 4,
    city_non_allocated: 6
  }
end
