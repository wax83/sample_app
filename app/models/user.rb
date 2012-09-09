class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  # email must be downcase before saving it to the db
  before_save { |user| user.email = user.email.downcase }

  validates :name, :email, presence: true
  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[\w+\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, :password_confirmation, 
              presence: true, length: { minimum: 6 }
end
