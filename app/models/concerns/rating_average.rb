module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0.0 if ratings.empty?

    (ratings.sum(:score) / ratings.count).to_f
  end
end
