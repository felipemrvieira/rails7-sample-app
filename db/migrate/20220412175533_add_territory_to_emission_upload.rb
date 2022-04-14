class AddTerritoryToEmissionUpload < ActiveRecord::Migration[7.0]
  def change
    add_reference :emission_uploads, :territory, null: false, foreign_key: true
  end
end
