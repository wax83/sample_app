class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy # user_spec:141

  # email must be downcase before saving it to the db
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token # changes with every save!

  validates :name, :email, presence: true
  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    # This is only a proto-feed.
    Micropost.where("user_id = ?", id) # simple sql,
    # all microposts corresponding to that id/user_id
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end  
end
