class AddGasesToEmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :emissions, :gas_id, :integer, index: true
  end
end
