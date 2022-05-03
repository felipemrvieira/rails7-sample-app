class EmissionUpload < ApplicationRecord
  belongs_to :admin
  belongs_to :sector
  belongs_to :territory
  has_many :emissions, dependent: :delete_all

  enum :status, { processing: 0, processed: 1, published: 2, failed: 3 }
end
