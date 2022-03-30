class Emission < ApplicationRecord
  belongs_to :emission_type
  belongs_to :territory
  belongs_to :sector
  belongs_to :gas
  belongs_to :economic_activity
  belongs_to :product
end
