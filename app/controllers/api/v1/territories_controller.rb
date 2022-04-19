class Api::V1::TerritoriesController < ApplicationController
  def index
    @territory = Territory.all
    render json: @territory
  end
  
  def states
    @territories = Territory.state
    render json: @territories
  end
  
  def search_city
    vars = request.query_parameters
    if vars['state_id'].present?
      state_acronym = Territory.find(vars['state_id']).acronym
      territories = Territory.city.where('lower(name) LIKE ?', "#{state_acronym.downcase} - #{vars['name'].downcase}%")
    else
      territories = Territory.city.where('lower(name) LIKE ?', "%#{vars['name'].downcase}%")
    end
    render json: territories
  end
end
