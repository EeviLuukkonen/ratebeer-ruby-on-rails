require 'rails_helper'

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password is too short" do
    user = User.create username: "Pekka", password: "Sec"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password has no upper letters" do
    user = User.create username: "Pekka", password: "secret1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end


  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end
  
    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favourite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_style).to eq("Lager")
    end

    it "is the one with highest rated beers if several rated" do
      beer1 = FactoryBot.create(:beer, style: "IPA")
      beer2 = FactoryBot.create(:beer, style: "IPA")
      beer3 = FactoryBot.create(:beer)

      FactoryBot.create(:rating, user: user, beer: beer1, score: 4)
      FactoryBot.create(:rating, user: user, beer: beer2, score: 3)
      FactoryBot.create(:rating, user: user, beer: beer3, score: 5)

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favourite brewery" do
    let(:user) { FactoryBot.create(:user) }
    let(:brewery) { FactoryBot.create(:brewery, name: "BrewDog") }
    let(:beer1) { FactoryBot.create(:beer) }
    let(:beer2) { FactoryBot.create(:beer, brewery: brewery) }
    let(:beer3) { FactoryBot.create(:beer, brewery: brewery) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      FactoryBot.create(:rating, score: 2, beer: beer1, user: user)
    
      expect(user.favorite_brewery).to eq("anonymous")
    end

    it "is the one with highest rated beers if several rated" do
      FactoryBot.create(:rating, user: user, beer: beer1, score: 6)
      FactoryBot.create(:rating, user: user, beer: beer2, score: 2)
      FactoryBot.create(:rating, user: user, beer: beer3, score: 10)

      expect(user.favorite_brewery).to eq("BrewDog")
    end
  end
end