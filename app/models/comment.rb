class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  after_create_commit -> { broadcast_append_to post }

  validates :content, presence: true
end
