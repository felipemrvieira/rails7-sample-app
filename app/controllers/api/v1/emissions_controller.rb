class Api::V1::EmissionsController < ApplicationController
  require 'csv'

  skip_before_action :verify_authenticity_token

  def index
    @emissions = Emission.all
    render json: @emissions
  end

  def create
    file = get_file
    sector = Sector.where(name: params[:sector_name]).first
    territory = get_territory

    AddEmissionsJob.new.perform(file, sector.id, territory.id)
    render json: {status: file}, status: :created
  end

  def consolidated

    sector = Sector.where(name: params[:sector_name]).first
    city = Territory.where(ibge_cod: params[:ibge_cod]).first if params[:ibge_cod] != 'all'

    emissions_upload = EmissionUpload.where(
      territory_id: params[:territory_id], 
      sector_id: sector.id,
    ).last

  

    if emissions_upload
     if params[:ibge_cod] != 'all'

      @total = emissions_upload.emissions.joins(:territory)
      .where(:territory => {:ibge_cod => params[:ibge_cod]})
      .where(year: params[:year])
      .order(year: :asc)
      .group(:year)
      .sum(:value)
      .map { |n| {year: n[0], value: n[1]} } if emissions_upload
      @total = [] if !emissions_upload

      @by_type = emissions_upload.emissions.joins(:territory)
      .where(:territory => {:ibge_cod => params[:ibge_cod]})
      .where(year: params[:year])
      .group(:emission_type_id)
      .distinct
      .sum(:value)
      
      @by_gas = emissions_upload.emissions.joins(:territory)
      .where(:territory => {:ibge_cod => params[:ibge_cod]})
      .where(year: params[:year])
      .group(:gas_id)
      .distinct
      .sum(:value)
    
     else
      @total = emissions_upload.emissions
      .where(year: params[:year])
      .order(year: :asc)
      .group(:year)
      .sum(:value)
      .map { |n| {year: n[0], value: n[1]} } if emissions_upload
      @total = [] if !emissions_upload
       
      @by_type = emissions_upload.emissions
      .where(year: params[:year])
      .group(:emission_type_id)
      .distinct
      .sum(:value)
      
      @by_gas = emissions_upload.emissions
      .where(year: params[:year])
      .group(:gas_id)
      .distinct
      .sum(:value)
     end
    else
      @by_type = []
      @by_gas = []
    end

  
  render json: {total: @total, by_type: @by_type, by_gas: @by_gas}, status: :ok
  # render json: city, status: :ok
  end

  def historical

    sector = Sector.where(name: params[:sector_name]).first
    city = Territory.where(ibge_cod: params[:ibge_cod]).first if params[:ibge_cod] != 'all'

    emissions_upload = EmissionUpload.where(
      territory_id: params[:territory_id], 
      sector_id: sector.id,
    ).last

    if emissions_upload
      if params[:ibge_cod] != 'all'

        @total = emissions_upload.emissions.joins(:territory)
        .where(:territory => {:ibge_cod => params[:ibge_cod]})
        .order(year: :asc)
        .group(:year)
        .sum(:value)
        .map { |n| {year: n[0], value: n[1]} } if emissions_upload
      else
        
        @total = emissions_upload.emissions
        .order(year: :asc)
        .group(:year)
        .sum(:value)
        .map { |n| {year: n[0], value: n[1]} } if emissions_upload
      end
    else
      @total = []
    end
   
  
  render json: {total: @total}, status: :ok
  # render json: city, status: :ok
  end

  private
    def get_file
      tmp = params[:csv_file].tempfile
      file = File.join("public", params[:csv_file].original_filename)
      FileUtils.cp tmp.path, file
      
      file
    end

    def get_territory
      acronym = CSV.read(get_file).second[9]
      Territory.where(acronym: acronym).first
    end

end
