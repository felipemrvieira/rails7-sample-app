class EmissionUpload < ApplicationRecord
  belongs_to :admin
  belongs_to :sector
  belongs_to :territory
  has_many :emissions
end
