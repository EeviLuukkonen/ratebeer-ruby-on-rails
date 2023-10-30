class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: 2023 }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
end
