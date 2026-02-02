class User < ApplicationRecord
  # Handles password hashing and authentication
  has_secure_password
  has_many :appointments, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w(user admin) }

  # Set default role before validation on create
  before_validation :set_default_role, on: :create

  # Check if user is admin
  def is_admin?
    role == 'admin'
  end

  # Password reset methods
  def generate_password_reset_token
    self.password_reset_token = SecureRandom.hex(32)
    self.password_reset_sent_at = Time.current
    save!
  end

  def password_reset_expired?
    password_reset_sent_at < 2.hours.ago
  end

  def reset_password(new_password, new_password_confirmation)
    if new_password == new_password_confirmation
      self.password = new_password
      self.password_confirmation = new_password_confirmation
      self.password_reset_token = nil
      self.password_reset_sent_at = nil
      save!
    else
      errors.add(:password, "doesn't match")
      false
    end
  end

  private

  # Assign default role if none provided
  def set_default_role
    self.role ||= 'user'
  end
end
