class Api::V1::GasesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @gases = Gas.all
    render json: @gases
  end
end
