class RatingJob
  include SuckerPunch::Job

  def perform(key, value)
    Rails.cache.write(key, value)
  end
end
