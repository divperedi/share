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
    Rails.logger.debug "Post destroyed: #{self.id}"
    broadcast_remove_to "posts_my"
    broadcast_remove_to "posts_ishare_#{user.id}"
    shared_users.each do |user|
      Turbo::StreamsChannel.broadcast_remove_to(
        "posts_shared_user_#{user.id}",
        target: dom_id(self)
      )
    end
  end
end
