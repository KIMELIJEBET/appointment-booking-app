class Api::AppointmentsController < Api::ApplicationController
  before_action :set_appointment, only: [:show, :update, :destroy]

  def index
    @appointments = current_user.appointments
    render json: @appointments.map { |apt| format_appointment(apt) }, status: :ok
  end

  def create
    @appointment = current_user.appointments.build(build_appointment_data)
    if @appointment.save
      render json: format_appointment(@appointment), status: :created
    else
      render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: format_appointment(@appointment), status: :ok
  end

  def update
    if @appointment.update(build_appointment_data)
      render json: format_appointment(@appointment), status: :ok
    else
      render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @appointment.destroy
      render json: { message: 'Appointment deleted successfully' }, status: :ok
    else
      render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
    unless @appointment.user_id == current_user.id
      render json: { message: 'Not authorized' }, status: :unauthorized and return
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Appointment not found' }, status: :not_found
  end

 def appointment_params
  params.require(:appointment).permit(
    :doctorName,
    :date,
    :time,
    :status,
    :reason
  )
 end

  # Map doctorName → patient_name, use `date` field
  def build_appointment_data
    data = appointment_params.to_h
    data['patient_name'] = data.delete('doctorName')
    
    # Combine date + time into the `date` column if both present
    if data['date'] && data['time']
      data['date'] = DateTime.parse("#{data.delete('date')} #{data.delete('time')}")
    end

    data
  end

  def format_appointment(appointment)
    {
      id: appointment.id,
      doctor_name: appointment.patient_name,
      date: appointment.date.to_date.to_s,
      time: appointment.date.strftime('%H:%M'),
      status: appointment.status,
      created_at: appointment.created_at,
      updated_at: appointment.updated_at
    }
  end
end
