class Api::V1::TotalEmissionsController < ApplicationController
  # include ChartHelpers

  def show
    @gases = Gas.business_order
    @emission_types = EmissionTypeCached.all
    @territories = TerritoryType.all
    @states = Territory.state
    @countries = Territory.country
    @comparations = comparations
  end

  def consolidated_per_year
    @emissions = Emission.joins(:sector)
      .where(:sector => {:name => params[:sector_name]})
      .order(year: :asc)
      .group(:year)
      .sum(:value)
      .map { |n| {year: n[0], value: n[1]} }

      # @emissions= Emission.where(year: 1990)
      
    render json: @emissions
  end

  def emission
    converted_params = parameters.to_h
    converted_params[:emission_type_id] =
      EmissionType.find_by(name: params[:emission_type])&.id

    converted_params[:emission_type_id] ||=
      EmissionTypeCached.emission_type_groupings(params[:emission_type])&.map(&:emission_type_id)

    if params[:territory_type] == 'city'
      converted_params[:territories] = parameters[:territories].map do |ibge_code|
        Territory.find_by(ibge_cod: ibge_code.to_i).id
      end
    end

    series = TotalEmissions.new(converted_params).series

    render json: series
  end

  def emissions_params
    emissions_params = {
      gases: Gas.business_order,
      emission_types: EmissionTypeCached.all
    }

    render json: emissions_params

  end


  private

  def parameters
    params.permit(
      :emission_type,
      :sector_name,
      :gas, 
      :social_economic, 
      territories: [], 
      year: []
    )
  end
end
