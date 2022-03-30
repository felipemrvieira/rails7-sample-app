class Api::V1::TerritoriesController < ApplicationController
  def index
    @territory = Territory.all
    render json: @territory
  end
end
