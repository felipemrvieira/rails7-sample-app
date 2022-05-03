class AddEmissionsJob < ApplicationJob
  queue_as :default

  before_perform :before_log
  after_perform :after_log
  
  require 'csv'
  require 'bigdecimal'
  require 'objspace'

  # territory_id is the id of the state
  def perform(csv_file, sector_id, territory_id)
    
    delete_last_emissions(sector_id, territory_id)

    emission_upload = create_emission_upload(csv_file, sector_id, territory_id)
    
    emission_types_hash = load_emission_types
    gases_hash = load_gases
    cities_hash = load_cities
    
    emissions_hash = []

    CSV.foreach(csv_file, headers: true) do |emission|
      
      # Year range for city emissions
      for year_index in 1990..2019
        emissions_hash << create_emission_hash(emission, year_index, 
          emission_types_hash, gases_hash, cities_hash, sector_id, emission_upload)
      end
      
      if ObjectSpace.memsize_of(emissions_hash) >= 500000
        puts "Persisting object bigger than 500Mb"
        
        Emission.insert_all(emissions_hash)
        emissions_hash = []
      end
      
    end
    
    # Insert remaining emissions
    result = Emission.insert_all(emissions_hash)
    
  end
  

  def before_log
    puts "Emissions Total Before --------->>>>>>>>>> #{Emission.count}" 
  end
  
  def after_log
    puts "Emissions Total After --------->>>>>>>>>> #{Emission.count}"
  end


  private
    def load_emission_types
      puts "Loading emission types..."
      
      emission_types_hash = Hash.new(:not_found)
      EmissionType.all.each do |item|
        # remove all spaces and convert to lowercase
        emission_types_hash[item.name.gsub(/\s+/, "").downcase] = item
      end

      emission_types_hash
    end

    def load_gases
      puts "Loading gases..."
      
      gases_hash = Hash.new(:not_found)
      Gas.all.each do |item|
        # remove all spaces and convert to lowercase
        gases_hash[item.name.gsub(/\s+/, "").downcase] = item
      end

      gases_hash
    end

    def load_cities
      puts "Loading cities..."
     
      cities_hash = Hash.new(:not_found)
      Territory.city.each do |item|
        cities_hash[item.ibge_cod] = item
      end

      cities_hash
    end

    def delete_last_emissions(sector_id, territory_id)
      # Delete all emissions per sector and territory before insert new ones
      puts "Delete all emissions per sector and territory before insert new ones"
     
      last_emission_upload = EmissionUpload.where(
        territory_id: territory_id, 
        sector_id: sector_id,
      ).last
      
      emissions = last_emission_upload.emissions if last_emission_upload
      emissions.delete_all if emissions
    end

    def create_emission_upload(csv_file, sector_id, territory_id)
      EmissionUpload.create(
        admin_id: 1,
        file_name: csv_file.split("/").last,
        status: :processing,
        sector_id: sector_id,
        territory_id: territory_id
      )
    end

    def create_emission_hash(emission, year_index, emission_types_hash, gases_hash, cities_hash, sector_id, emission_upload)
      {
        year:                   year_index,
        value:                  BigDecimal(emission.field(year_index.to_s).gsub(',', '.')),
        emission_type_id:       emission_types_hash[emission.field("TIPO DE EMISSAO").gsub(/\s+/, "").downcase].id,
        sector_id:              sector_id,
        gas_id:                 gases_hash[emission.field("GÁS").gsub(/\s+/, "").downcase].id,
        emission_upload_id:     emission_upload.id,
        territory_id:           cities_hash[emission.field("IBGE").to_i].id,
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