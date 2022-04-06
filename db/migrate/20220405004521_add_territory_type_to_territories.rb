class AddTerritoryTypeToTerritories < ActiveRecord::Migration[7.0]
  def change
    add_column :territories, :territory_type, :integer, index: true, null: false
  end
end
