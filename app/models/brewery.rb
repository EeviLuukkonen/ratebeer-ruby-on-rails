class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040 }
  validate :year_cannot_be_in_the_future

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_cannot_be_in_the_future
    return unless year > Time.now.year

    errors.add(:year, "year cannot be in the future!")
  end
end
