class CreateSectors < ActiveRecord::Migration[7.0]
  def change
    create_table :sectors do |t|
      t.string :name
      t.string :slug
      t.string :base_color
      t.string :level_2_description
      t.string :level_3_description
      t.string :level_4_description
      t.string :level_5_description
      t.string :level_6_description

      t.timestamps
    end
  end
end
