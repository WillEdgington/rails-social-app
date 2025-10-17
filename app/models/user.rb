class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 15 },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "can only contain letters, numbers and underscores" }
  
  before_save :downcase_username

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
  has_many :requested_followers, through: :passive_follows, source: :follower

  has_one_attached :avatar
  validate :acceptable_avatar

  def following
    requested_following.merge(Follow.accepted)
  end

  def followers
    requested_followers.merge(Follow.accepted)
  end

  def pending_follow_requests
    passive_follows.pending
  end

  private

  def downcase_username
    self.username = username.downcase
  end

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.content_type.start_with?("image/")
      errors.add(:avatar, "must be an image")
    end

    if avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "is too big (max 5MB)")
    end
  end
end
