require 'spec_helper'

describe User do

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq nil
    end

    it "is the only rated if only one rating" do
      create_beer_with_style_and_rating "Tumma", 35, user

      expect(user.favorite_style).to eq "Tumma"
    end

    it "is the one with highest average rating" do
      create_beer_with_style_and_rating "Vehnä", 30, user
      create_beer_with_style_and_rating "Vehnä", 35, user
      create_beer_with_style_and_rating "Tumma", 10, user
      create_beer_with_style_and_rating "Tumma", 20, user

      expect(user.favorite_style).to eq "Vehnä"
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq nil
    end

    it "is the only rated if only one rating" do
      brewery = FactoryGirl.create :brewery, name: "Brewdog"
      beer = create_beer_with_brewery_and_rating brewery, 33, user

      expect(user.favorite_brewery).to eq brewery
    end

    it "is the one with highest average rating" do
      dog = FactoryGirl.create :brewery, name: "Brewdog"
      olvi = FactoryGirl.create :brewery, name: "olvi"
      create_beer_with_brewery_and_rating dog, 20, user
      create_beer_with_brewery_and_rating dog, 25, user
      create_beer_with_brewery_and_rating olvi, 20, user
      create_beer_with_brewery_and_rating olvi, 10, user

      expect(user.favorite_brewery).to eq dog
    end
  end  

  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a short password" do
    user = User.create username:"Pekka", password:"pa1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved without a proper password" do
    user = User.create username:"Pekka", password:"testtest"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end

def create_beer_with_style_and_rating(style, score, user)
  beer = FactoryGirl.create :beer, style: style
  FactoryGirl.create :rating, score:score, beer:beer, user:user
  return beer
end

def create_beer_with_brewery_and_rating(brewery, score, user)
  beer = FactoryGirl.create :beer, brewery: brewery
  FactoryGirl.create :rating, score:score, beer:beer, user:user
  return beer
end  
end