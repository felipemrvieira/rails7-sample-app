class Api::V1::Admins::RegistrationsController < DeviseTokenAuth::RegistrationsController
  skip_before_action :verify_authenticity_token

  def render_create_success
    render json: @resource
  end

  def render_update_success
    render json: @resource
  end

  private

  def sign_up_params
    params.permit(:name, :nickname, :email, :password, :cpf, :phone, 
      :status, :password_confirmation, :avatar)
  end

end