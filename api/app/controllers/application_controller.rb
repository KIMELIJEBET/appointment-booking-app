class Api::ApplicationController < ApplicationController
  before_action :set_default_response_format
  before_action :authorize_request

  attr_reader :current_user

  private

  # Ensure JSON responses
  def set_default_response_format
    request.format = :json
  end

  # JWT-based authentication
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')[0]
      @current_user = User.find(decoded['user_id'])
    rescue
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end
end
