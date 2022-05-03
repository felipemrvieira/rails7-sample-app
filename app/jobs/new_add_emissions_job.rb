class NewAddEmissionsJob < ApplicationJob
  queue_as :default
  before_perform :print_before_perform_message
  after_perform :print_after_perform_message

  require 'csv'
  require 'bigdecimal'
  require 'objspace'

  def print_before_perform_message
    puts "Printing from inside before_perform callback"
  end

  def print_after_perform_message
    puts "Printing from inside after_perform callback"
  end

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
      status: :processing,
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
    
    puts "Emissions Total Before --------->>>>>>>>>> #{Emission.count}" 
    
    CSV.foreach(csv_file, headers: true) do |emission|
      
      # Year range for city emissions
      for year_index in 1990..2019
        
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
    
    puts "Emissions hash size --------->>>>>>>>>> #{ObjectSpace.memsize_of(emissions)}"

    my_proc = ->(rows_size, num_batches, current_batch_number, batch_duration_in_secs) {
      # Using the arguments provided to the callable, you can
      # send an email, post to a websocket,
      # update slack, alert if import is taking too long, etc.
      puts "---- ------- PROGRESS ------- ----"
      puts "---- ------- rows size #{rows_size} ------- ----"
      puts "---- ------- num batches #{num_batches} ------- ----"
      puts "---- ------- current batch number #{current_batch_number} ------- ----"
      puts "---- ------- batch duration #{batch_duration_in_secs} ------- ----"
    }
    
    Emission.import emissions, validate: false, batch_size: 10000, batch_progress: my_proc

    puts "Emissions Total After --------->>>>>>>>>> #{Emission.count}"

    puts "Performed by #{self.class.name} at #{Time.now}"
    
    emission_upload.update(status: :processed)
  end
  
end