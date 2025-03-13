class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :shared_posts, dependent: :destroy, class_name: "SharedPost"
  has_many :shared_users, through: :shared_posts, source: :user

  validates :title, presence: true
  validates :body, presence: true

  after_create_commit -> { broadcast_prepend_to "posts_my" }
  after_update_commit -> { broadcast_replace_to self }
  after_destroy_commit do
    broadcast_remove_to "posts_my"

    # Remove post from all "Shared with Me" lists when deleted
    shared_users.each do |user|
      broadcast_remove_to view_context.dom_id(user, :posts_shared)
    end
  end
end
