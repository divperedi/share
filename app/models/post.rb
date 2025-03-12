class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :shared_posts, dependent: :destroy, class_name: 'SharedPost'
  has_many :shared_users, through: :shared_posts, source: :user

  validates :title, presence: true
  validates :body, presence: true
end