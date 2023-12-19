class Beer < ApplicationRecord
  include RatingAverage
  extend Top

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def to_s
    "#{name},  #{brewery.name}"
  end

  def self.top_styles(amount)
    # koska viikolla 5 jäi toteuttamatta stylet tietokantatasolla, selvitetään top styles oluen kautta
    styles = Beer.all.group_by(&:style)

    average_ratings = self.average_ratings(styles)

    sorted_styles = average_ratings.sort_by { |_, rating| rating }.reverse

    sorted_styles.take(amount)
  end

  def self.average_ratings(styles)
    styles.transform_values do |beers|
      total_score = beers.sum { |beer| beer.ratings.sum(:score) }
      total_ratings = beers.sum { |beer| beer.ratings.count }

      total_ratings.zero? ? 0 : (total_score.to_f / total_ratings)
    end
  end
end
