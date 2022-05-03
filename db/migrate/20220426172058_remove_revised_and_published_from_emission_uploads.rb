class RemoveRevisedAndPublishedFromEmissionUploads < ActiveRecord::Migration[7.0]
  def change
    remove_column :emission_uploads, :revised, :boolean
    remove_column :emission_uploads, :published, :boolean
  end
end
