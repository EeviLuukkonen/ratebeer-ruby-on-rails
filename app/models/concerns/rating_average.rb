module RatingAverage
  extend ActiveSupport::Concern
 
  def average_rating
    if ratings.empty?
      return nil
    else
      return (ratings.sum(:score) / ratings.count).to_f
    end
  end
end