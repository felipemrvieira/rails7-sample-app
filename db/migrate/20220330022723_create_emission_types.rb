class CreateEmissionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :emission_types do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
