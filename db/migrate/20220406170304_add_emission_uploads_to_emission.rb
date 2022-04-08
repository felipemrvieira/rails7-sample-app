class AddEmissionUploadsToEmission < ActiveRecord::Migration[7.0]
  def change
    add_reference :emissions, :emission_upload, null: false, foreign_key: true
  end
end
