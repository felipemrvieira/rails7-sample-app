class AddEmissionsJob
  require 'csv'
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(csv_file)
    # Delete all emissions per sector before insert new ones
    # Emission.delete_by(email: "abhay@example.com", rating: 4)
    Emission.delete_all

    emissions = []

    CSV.foreach(csv_file, headers: true) do |emission|

      # Year range for city emissions
      for year_index in 1990..2019

        emissions << {
          year: year_index,
          value: emission.field(year_index.to_s),
          emission_type_id: 1,
          territory_id: 1,
          sector_id: 4,
          economic_activity_id: 1,
          product_id: 1,
          gas_id: 1,
          # gas_id: emission.field("GÁS"),
          level_2_id: 1,
          level_3_id: 1,
          level_4_id: 1,
          level_5_id: 1,
          level_6_id: 1
        }

      end
    end

    puts "Emissions Total Before --------->>>>>>>>>> #{Emission.count}" 
    result = Emission.insert_all(emissions)
    puts "Emissions Total After --------->>>>>>>>>> #{Emission.count}"

    puts result.inspect

  end

end