class AddStatusToEmissionsUpload < ActiveRecord::Migration[7.0]
  def change
    add_column :emission_uploads, :status, :integer, default: 0
  end
end
