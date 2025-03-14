class SharedPost < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :post

  # After the post is shared, broadcast it to both the target user and the author
  after_create_commit do
    # Ensure the post appears in "Shared with Me"
    broadcast_prepend_to [ user, :posts_shared ],
      target: "#{dom_id(user, :posts_shared)}_posts",
      partial: "posts/post",
      locals: { post: post, show_share_form: false, show_link: true }

    # Ensure the post appears in "I Share"
    broadcast_prepend_to "posts_ishare_#{post.user.id}",
      target: "posts_ishare",
      partial: "posts/post",
      locals: { post: post, show_share_form: false, show_link: true }
  end


  # When the shared post is destroyed, remove it from both "Shared with Me" and "I Share"
  after_destroy_commit do
    broadcast_remove_to [ user, :posts_shared ]  # Remove from "Shared with Me"
    broadcast_remove_to "posts_ishare"  # Remove from "I Share"
  end
end
