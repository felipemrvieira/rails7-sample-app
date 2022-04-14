class Api::V1::EmissionUploadsController < ApplicationController
  before_action :set_emission_upload, only: %i[ show edit update destroy ]

  def index
    @emission_uploads = EmissionUpload.all.order(created_at: :desc)
    render json: @emission_uploads, include: :admin
  end

  def per_sector
    @emission_uploads = EmissionUpload.joins(:sector, :territory)
                          .where(:sector => {:name => params[:sector_name]})
    
    @emission_uploads = @emission_uploads.where(
      :territory => {:id => params[:territory_id]}) if params[:territory_id] != "all"
    
    render json: @emission_uploads, include: :admin
  end

  # GET /emission_uploads/1 or /emission_uploads/1.json
  def show
  end

  # GET /emission_uploads/new
  def new
    @emission_upload = EmissionUpload.new
  end

  # GET /emission_uploads/1/edit
  def edit
  end

  # POST /emission_uploads or /emission_uploads.json
  def create
    @emission_upload = EmissionUpload.new(emission_upload_params)

    respond_to do |format|
      if @emission_upload.save
        format.html { redirect_to emission_upload_url(@emission_upload), notice: "Emission upload was successfully created." }
        format.json { render :show, status: :created, location: @emission_upload }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @emission_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /emission_uploads/1 or /emission_uploads/1.json
  def update
    respond_to do |format|
      if @emission_upload.update(emission_upload_params)
        format.html { redirect_to emission_upload_url(@emission_upload), notice: "Emission upload was successfully updated." }
        format.json { render :show, status: :ok, location: @emission_upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @emission_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /emission_uploads/1 or /emission_uploads/1.json
  def destroy
    @emission_upload.destroy

    respond_to do |format|
      format.html { redirect_to emission_uploads_url, notice: "Emission upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emission_upload
      @emission_upload = EmissionUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def emission_upload_params
      params.require(:emission_upload).permit(
        :revised, 
        :published, 
        :file_name, 
        :admin_id, 
        :sector_name,
        :territory_id)
    end
end
