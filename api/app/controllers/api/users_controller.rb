# app/controllers/api/users_controller.rb
class Api::UsersController < Api::ApplicationController
  skip_before_action :authorize_request, only: [:create]

  # POST /api/users
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully', user: user.as_json(except: [:password_digest, :password_reset_token, :password_reset_sent_at]) }, status: :created
    else
      render json: { message: 'Failed to create user', errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/users
  def index
    users = User.all
    render json: users.as_json(except: [:password_digest, :password_reset_token, :password_reset_sent_at])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
