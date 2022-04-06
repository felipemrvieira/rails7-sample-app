class Api::V1::EmissionTypesController < ApplicationController
  def index
    @emission_types = EmissionType.all
    render json: @emission_types
  end
end
