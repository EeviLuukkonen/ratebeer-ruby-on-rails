module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return nil if ratings.empty?

    (ratings.sum(:score) / ratings.count).to_f
  end
end
