class Api::V1::GasesController < ApplicationController
  def index
    @gases = Gas.all
    render json: @gases
  end
end
