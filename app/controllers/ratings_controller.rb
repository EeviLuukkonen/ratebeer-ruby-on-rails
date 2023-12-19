class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]

  def index
    # Nopeutin metodia Sucker Punchia ja cachea käyttämällä.
    # Kaikki tiedot haetaan välimuistista, ja jos niitä ei ole,
    # tehdään tietokantakyselyt ja lisätään ne välimuistiin.
    cache_keys = %w[recent_ratings top_breweries top_beers top_styles top_raters]
    @recent_ratings, @top_breweries, @top_beers, @top_styles, @top_raters = cache_keys.map do |key|
      Rails.cache.read(key) || perform_and_cache(key)
    end

    @ratings = Rating.all
  end

  def perform_and_cache(key)
    data = case key
           when 'recent_ratings'
             Rating.recent
           when 'top_breweries'
             Brewery.top(3)
           when 'top_beers'
             Beer.includes(:brewery, :ratings).top(3)
           when 'top_styles'
             Beer.top_styles(3)
           when 'top_raters'
             User.top(3)
           end

    RatingJob.perform_async(key, data)
    data
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
