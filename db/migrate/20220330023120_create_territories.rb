class CreateTerritories < ActiveRecord::Migration[7.0]
  def change
    create_table :territories do |t|
      t.string :name
      t.string :slug
      t.integer :parent_id
      t.string :territory_type
      t.integer :ibge_cod
      t.string :acronym
      t.string :flag_path

      t.timestamps
    end
  end
end
