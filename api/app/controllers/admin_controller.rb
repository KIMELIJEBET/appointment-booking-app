class Api::AdminController < Api::ApplicationController
  before_action :admin_only

  # GET /api/admin/dashboard
  def dashboard
    render json: {
      total_users: User.count,
      total_appointments: Appointment.count,
      total_admins: User.where(role: 'admin').count,
      total_regular_users: User.where(role: 'user').count
    }, status: :ok
  end

  # GET /api/admin/users
  def users
    render json: User.all, status: :ok
  end

  # GET /api/admin/users/:id
  def user_details
    user = find_user
    return unless user

    render json: {
      user: user,
      appointments_count: user.appointments.count,
      appointments: user.appointments
    }, status: :ok
  end

  # DELETE /api/admin/users/:id
  def delete_user
    user = find_user
    return unless user

    if user.id == current_user.id
      render json: { message: 'Cannot delete your own account' }, status: :unprocessable_entity
      return
    end

    destroy_resource(user, 'User')
  end

  # GET /api/admin/appointments
  def all_appointments
    appointments = Appointment.includes(:user).all
    render json: appointments.map { |apt|
      apt.attributes.merge(user_name: apt.user.name, user_email: apt.user.email)
    }, status: :ok
  end

  # DELETE /api/admin/appointments/:id
  def delete_appointment
    appointment = find_appointment
    return unless appointment

    destroy_resource(appointment, 'Appointment')
  end

  # PATCH /api/admin/users/:id/promote
  def promote_user
    user = find_user
    return unless user

    update_role(user, 'admin', 'User promoted to admin')
  end

  # PATCH /api/admin/users/:id/demote
  def demote_user
    user = find_user
    return unless user

    if user.id == current_user.id
      render json: { message: 'Cannot demote yourself' }, status: :unprocessable_entity
      return
    end

    update_role(user, 'user', 'User demoted to regular user')
  end

  private

  # Admin-only access check
  def admin_only
    render json: { message: 'Admin access required' }, status: :forbidden unless current_user.is_admin?
  end

  # Helper: find user by params[:id]
  def find_user
    User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'User not found' }, status: :not_found
    nil
  end

  # Helper: find appointment by params[:id]
  def find_appointment
    Appointment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Appointment not found' }, status: :not_found
    nil
  end

  # Helper: destroy any ActiveRecord object
  def destroy_resource(resource, name)
    if resource.destroy
      render json: { message: "#{name} deleted successfully" }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Helper: update user role
  def update_role(user, role, success_message)
    if user.update(role: role)
      render json: { message: success_message, user: user }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
