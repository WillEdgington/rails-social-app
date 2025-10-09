class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  
  enum :status, { pending: 0, accepted: 1 }

  validates :follower_id, uniqueness: { scope: :followed_id }
end
