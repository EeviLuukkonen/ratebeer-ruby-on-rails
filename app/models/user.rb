class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 }
  validates :password, format: { with: /^(?=.*[A-Z])(?=.*\d)/, message: "must contain at least one uppercase letter and one number", multiline: true }

  has_many :ratings, dependent: :destroy
end
