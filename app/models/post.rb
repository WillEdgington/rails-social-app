class Post < ApplicationRecord
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :title, presence: true,
                    length: { minimum: 1, maximum: 50 }
  validates :body, presence: true,
                   length: { minimum: 2, maximum: 10000 }
end
