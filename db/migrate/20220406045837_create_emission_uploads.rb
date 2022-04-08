class CreateEmissionUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :emission_uploads do |t|
      t.boolean :revised
      t.boolean :published
      t.string :file_name
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
