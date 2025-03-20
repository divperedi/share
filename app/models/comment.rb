class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  broadcasts_to ->(comment) { "comments_#{comment.post.id}" }, inserts_by: :append
end
