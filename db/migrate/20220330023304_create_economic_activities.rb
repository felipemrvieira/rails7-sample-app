class CreateEconomicActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :economic_activities do |t|
      t.string :name
      t.string :acronym
      t.string :slug
      t.string :sankey_grouping

      t.timestamps
    end
  end
end
