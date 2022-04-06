class Api::V1::EmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @emissions = Emission.all
    render json: @emissions
  end

  def create
    file = get_file
    AddEmissionsJob.new.perform(file)
    render json: {status: file}, status: :created
  end

  private
    def get_file
      tmp = params[:csv_file].tempfile
      file = File.join("public", params[:csv_file].original_filename)
      FileUtils.cp tmp.path, file
      
      file
    end

end
