class SharedPost < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :post

  # After the post is shared, broadcast it to both the target user and the author
  after_create_commit do
    # Broadcast to "Shared with Me" for the user who received the share
    broadcast_prepend_to [ user, :posts_shared ], target: "#{dom_id(user, :posts_shared)}_posts", partial: "posts/post", locals: { post: post, show_share_form: false, show_link: true }
    # Broadcast to "I Share" for the post author
    broadcast_prepend_to [ post.user, :posts_ishare ], target: "posts-ishare", partial: "posts/post", locals: { post: post, show_share_form: false, show_link: true }
  end

  # When the shared post is destroyed, remove it from both "Shared with Me" and "I Share"
  after_destroy_commit do
    broadcast_remove_to [ user, :posts_shared ]  # Remove from "Shared with Me"
    broadcast_remove_to [ post.user, :posts_ishare ]  # Remove from "I Share"
  end
end
