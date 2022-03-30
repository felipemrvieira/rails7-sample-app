class CreateEmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :emissions do |t|
      t.integer :year
      t.decimal :value
      t.references :emission_type, null: false, foreign_key: true
      t.references :territory, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true
      t.references :economic_activity, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
