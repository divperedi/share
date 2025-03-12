class User < ApplicationRecord
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :shared_posts, dependent: :destroy, class_name: "SharedPost"
  has_many :shared_posts_received, through: :shared_posts, source: :post

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :username, presence: true, uniqueness: true

  def self.authenticate_by(login, password)
    user = find_by("email_address = :value OR username = :value", value: login)
    user&.authenticate(password)
  end
end
