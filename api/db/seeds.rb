# db/seeds.rb

# Clear existing data
Appointment.destroy_all
User.destroy_all

puts "Seeding users..."

# Admin
admin = User.create!(
  name: "Admin User",
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  role: "admin"
)

# Regular users
user1 = User.create!(
  name: "John Doe",
  email: "john@example.com",
  password: "password",
  password_confirmation: "password",
  role: "user"
)

user2 = User.create!(
  name: "Jane Smith",
  email: "jane@example.com",
  password: "password",
  password_confirmation: "password",
  role: "user"
)

puts "Seeding appointments..."

# Check which columns exist in Appointment table
columns = Appointment.column_names

appointments_data = [
  { user: user1, patient_name: "John Doe", date: DateTime.now + 1.day, status: "pending" },
  { user: user1, patient_name: "John Doe", date: DateTime.now + 3.days, status: "pending" },
  { user: user2, patient_name: "Jane Smith", date: DateTime.now + 2.days, status: "pending" },
  { user: user2, patient_name: "Jane Smith", date: DateTime.now + 5.days, status: "pending" }
]

# Include reason only if column exists
appointments_data.each do |apt_data|
  apt_data[:reason] = "General Checkup" if columns.include?("reason")
end

Appointment.create!(appointments_data)

puts "Seeding completed!"
