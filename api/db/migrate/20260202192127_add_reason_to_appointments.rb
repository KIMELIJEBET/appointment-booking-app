class AddReasonToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_column :appointments, :reason, :string
  end
end
