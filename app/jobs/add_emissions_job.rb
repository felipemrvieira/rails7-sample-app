class AddEmissionsJob
  require 'csv'
  require 'bigdecimal'
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(csv_file, sector_id, territory_id)
    # Delete all emissions per sector before insert new ones
    Emission.delete_by(sector_id: sector_id)
    
    emission_upload = EmissionUpload.create(
      admin_id: 1,
      file_name: csv_file.split("/").last,
      published: false,
      revised: false,
      sector_id: sector_id,
      territory_id: territory_id
    )
    
    emissions = []
    
    CSV.foreach(csv_file, headers: true) do |emission|
      
      # Year range for city emissions
      for year_index in 1990..2019

        puts emission.field(year_index.to_s) 
        
        emissions << {
          year: year_index,
          value: BigDecimal(emission.field(year_index.to_s).gsub(',', '.')),
          emission_type_id: rand(1..8),
          # territory_uf: emission.field("TERRITÓRIO"),
          territory_id: 1,
          sector_id: sector_id,
          economic_activity_id: 1,
          product_id: 1,
          gas_id: 1,
          # gas_id: emission.field("GÁS"),
          level_2_id: 1,
          level_3_id: 1,
          level_4_id: 1,
          level_5_id: 1,
          level_6_id: 1,
          emission_upload_id: emission_upload.id
        }

      end
    end
    
    puts "Emissions Total Before --------->>>>>>>>>> #{Emission.count}" 
    result = Emission.insert_all(emissions)
    puts "Emissions Total After --------->>>>>>>>>> #{Emission.count}"
    
    # puts result.inspect
    puts sector_id
    
  end
  
end