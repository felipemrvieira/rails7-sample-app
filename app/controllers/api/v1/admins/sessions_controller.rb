class Api::V1::Admins::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :verify_authenticity_token

  def render_create_success
    render json: @resource
  end

  private

  def sign_in_params
    params.permit(:email, :password, :password_confirmation)
  end
end