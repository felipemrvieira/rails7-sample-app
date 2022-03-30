class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :acronym
      t.string :slug

      t.timestamps
    end
  end
end
