class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  default_scope order: "microposts.created_at DESC"

  # class method for the feed
  def self.from_user_followed_by(user)
    where("user_id IN (?) OR user_id = ?", user.followed_user_ids, user.id)
    # user.followed_user_ids = user_followed_users.map { |user| user.id }
  end
end
