class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :active_follows, class_name: "Follow",
                            foreign_key: "follower_id",
                            dependent: :destroy
  has_many :requested_following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow",
                             foreign_key: "followed_id",
                             dependent: :destroy
  has_many :requested_followers, through: :passive_followes, source: :follower

  def following
    requested_following.merge(Follow.accepted)
  end

  def followers
    requested_followers.merge(Follow.accepted)
  end

  def pending_follow_requests
    passive_follows.pending
  end
end
