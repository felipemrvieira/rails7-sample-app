class Emission < ApplicationRecord
  belongs_to :emission_type
  belongs_to :territory
  belongs_to :sector
  belongs_to :level_2, class_name: 'Level'
  belongs_to :level_3, class_name: 'Level'
  belongs_to :level_4, class_name: 'Level'
  belongs_to :level_5, class_name: 'Level'
  belongs_to :level_6, class_name: 'Level'
  belongs_to :gas
  belongs_to :economic_activity
  belongs_to :product
  belongs_to :emission_upload, dependent: :delete
end
