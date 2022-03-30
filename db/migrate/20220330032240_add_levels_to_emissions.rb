class AddLevelsToEmissions < ActiveRecord::Migration[7.0]
  def change
    add_column :emissions, :level_2_id, :integer
    add_column :emissions, :level_3_id, :integer
    add_column :emissions, :level_4_id, :integer
    add_column :emissions, :level_5_id, :integer
    add_column :emissions, :level_6_id, :integer
  end
end
