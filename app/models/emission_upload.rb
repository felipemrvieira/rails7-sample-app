class EmissionUpload < ApplicationRecord
  belongs_to :admin
  belongs_to :sector
  has_many :emissions
end
