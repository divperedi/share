class SharedPost < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :user
  belongs_to :post

  after_create_commit do
    broadcast_prepend_to [ user, :posts_shared ],
      target: "#{dom_id(user, :posts_shared)}_posts",
      partial: "posts/post",
      locals: { post: post, show_share_form: false, show_link: true }

    broadcast_prepend_to "posts_ishare_#{post.user.id}",
      target: "posts_ishare",
      partial: "posts/post",
      locals: { post: post, show_share_form: false, show_link: true }
  end

  after_destroy_commit do
    broadcast_remove_to [ user, :posts_shared ]
    broadcast_remove_to "posts_ishare"
  end
end
