class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 }
  validates :password, format: { with: /^(?=.*[A-Z])(?=.*\d)/, message: "must contain at least one uppercase letter and one number", multiline: true }

  has_many :ratings, dependent: :destroy
  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ratings.group_by { |rating| rating.beer.style }

    average_scores = {}
    styles.each do |style, style_ratings|
      total_score = style_ratings.sum(&:score).to_f
      average_scores[style] = total_score / style_ratings.count
    end
    average_scores.max_by { |average_score| average_score }&.first
  end
end
