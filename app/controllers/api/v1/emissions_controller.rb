class Api::V1::EmissionsController < ApplicationController
  def index
    @emissions = Emission.all
    render json: @emissions
  end
end
