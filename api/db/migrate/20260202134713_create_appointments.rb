class CreateAppointments < ActiveRecord::Migration[8.1]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :patient_name
      t.string :doctor_name
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
