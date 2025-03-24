class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create_commit do
    broadcast_append_to [ post, "comments" ], target: "comments_#{post.id}"
  end
end
