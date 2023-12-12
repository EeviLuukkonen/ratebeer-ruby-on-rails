class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 }
  validates :password, format: { with: /^(?=.*[A-Z])(?=.*\d)/, message: "must contain at least one uppercase letter and one number", multiline: true }

  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  has_many :ratings, dependent: :destroy
  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ratings.group_by { |rating| rating.beer.style }

    total_scores = {}
    styles.each do |style, style_ratings|
      total_scores[style] = style_ratings.sum(&:score)
    end
    total_scores.max_by { |_style, total_score| total_score }&.first
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = ratings.group_by { |rating| rating.beer.brewery }

    total_scores = {}
    breweries.each do |brewery, brewery_ratings|
      total_scores[brewery.name] = brewery_ratings.sum(&:score)
    end

    total_scores.max_by { |_brewery, total_score| total_score }&.first
  end

  def self.top(amount)
    sorted_users = User
                   .select('users.*, COUNT(ratings.id) AS ratings_count')
                   .joins(:ratings)
                   .group('users.id')
                   .order('COUNT(ratings.id) DESC')

    sorted_users.take(amount)
  end
end
