class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password # creates the authenticate method

  has_many :microposts, dependent: :destroy 
  has_many :relationships, foreign_key: "follower_id", 
                           dependent: :destroy

  has_many :followed_users, through: :relationships, 
                            source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy

  has_many :followers, through: :reverse_relationships#, source: :follower

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

  # Utility methods
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  # user.feed
  def feed
    # mposts from the user whos followed by THE user!!
    Micropost.from_user_followed_by(self)
    # this is gonna be a class method on Micropost.
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end  
end
