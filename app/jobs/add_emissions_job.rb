class AddEmissionsJob
  require 'csv'
  require 'bigdecimal'
  include Sidekiq::Worker
  sidekiq_options retry: false

  # territory_id is the id of the state
  def perform(csv_file, sector_id, territory_id)
    # Delete all emissions per sector and territory before insert new ones
   
    last_emission_upload = EmissionUpload.where(
      territory_id: territory_id, 
      sector_id: sector_id,
    ).last
    
    emissions = last_emission_upload.emissions if last_emission_upload
    emissions.delete_all if emissions

    # EmissionUpload.emissions.delete_by(
    #   sector_id: sector_id, 
    #   territory_id: territory_id
    # )
    

    emission_upload = EmissionUpload.create(
      admin_id: 1,
      file_name: csv_file.split("/").last,
      published: false,
      revised: false,
      sector_id: sector_id,
      territory_id: territory_id
    )
    
    emissions = []

    puts "Loading emission types..."
    emission_type_hash = Hash.new(:not_found)
    EmissionType.all.each do |item|
      # remove all spaces and convert to lowercase
      emission_type_hash[item.name.gsub(/\s+/, "").downcase] = item
    end
   
    puts "Loading gases..."
    gas_hash = Hash.new(:not_found)
    Gas.all.each do |item|
      # remove all spaces and convert to lowercase
      gas_hash[item.name.gsub(/\s+/, "").downcase] = item
    end
   
    puts "Loading cities..."
    city_hash = Hash.new(:not_found)
    Territory.city.each do |item|
      city_hash[item.ibge_cod] = item
    end
    
    CSV.foreach(csv_file, headers: true) do |emission|
      
      # Year range for city emissions
      for year_index in 1990..2019
        puts city_hash[emission.field("IBGE").to_i].id
        
        emissions << {
          year:                   year_index,
          value:                  BigDecimal(emission.field(year_index.to_s).gsub(',', '.')),
          emission_type_id:       emission_type_hash[emission.field("TIPO DE EMISSAO").gsub(/\s+/, "").downcase].id,
          sector_id:              sector_id,
          gas_id:                 gas_hash[emission.field("GÁS").gsub(/\s+/, "").downcase].id,
          emission_upload_id:     emission_upload.id,
          territory_id:           city_hash[emission.field("IBGE").to_i].id,
          economic_activity_id:   1,
          product_id:             1,
          level_2_id:             1,
          level_3_id:             1,
          level_4_id:             1,
          level_5_id:             1,
          level_6_id:             1
        }

      end
    end
    
    puts "Emissions Total Before --------->>>>>>>>>> #{Emission.count}" 
    result = Emission.insert_all(emissions)
    puts "Emissions Total After --------->>>>>>>>>> #{Emission.count}"
    
    # puts result.inspect    
  end
  
end