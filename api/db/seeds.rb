# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data (optional, for fresh seeding)
Appointment.destroy_all
User.destroy_all

# Create users
admin = User.create!(
  name: "Admin",
  email: "admin@example.com",
  password: "password123",
  role: "admin"
)

user1 = User.create!(
  name: "John Doe",
  email: "john@example.com",
  password: "secret123",
  role: "user"
)

user2 = User.create!(
  name: "Jane Smith",
  email: "jane@example.com",
  password: "secret123",
  role: "user"
)

# Create appointments
Appointment.create!(
  user: user1,
  patient_name: "John Doe",
  doctor_name: "Dr. Smith",
  date: Date.today,
  time: "10:00",
  reason: "Routine checkup"
)

Appointment.create!(
  user: user2,
  patient_name: "Jane Smith",
  doctor_name: "Dr. Adams",
  date: Date.today + 1,
  time: "14:30",
  reason: "Consultation"
)