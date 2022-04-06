class Api::V1::TerritoriesController < ApplicationController
  def index
    @territory = Territory.all
    render json: @territory
  end
  
  def search_city
    vars = request.query_parameters
    territories = Territory.city.where('lower(name) LIKE ?', "%#{vars['name'].downcase}%")
    render json: territories
  end
end
