class AddPatientNameToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_column :appointments, :patient_name, :string
  end
end
