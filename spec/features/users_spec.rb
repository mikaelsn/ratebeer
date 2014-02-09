require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    @user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
      }.to change{User.count}.by(1)
    end

    describe "who has logged in" do
      let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
      let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style: "Lager" }
      let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
      before :each do
        sign_in(username:"Pekka", password:"Foobar1")
      end

      it "should see the number of ratings made on user page" do
        FactoryGirl.create :user, username: "kalle", password: "Test123", password_confirmation: "Test123"
        FactoryGirl.create :rating, beer_id: 1, score: 30, user_id: 1
        FactoryGirl.create :rating, beer_id: 1, score: 40, user_id: 2
        FactoryGirl.create :rating, beer_id: 2, score: 40, user_id: 2

        visit user_path(@user)
        expect(page).to have_content "Has given #{@user.ratings.count}"
      end

      it "should see favorite beer, style and brewery" do
        FactoryGirl.create :rating, beer_id: 1, score: 30, user_id: 1
        FactoryGirl.create :rating, beer_id: 1, score: 40, user_id: 1
        FactoryGirl.create :rating, beer_id: 2, score: 40, user_id: 1
        visit user_path(@user)
        expect(page).to have_content "Favorite beer is iso 3, Favorite style is Lager, favorite brewery is Koff"
      end

      it "should delete own ratings" do
        FactoryGirl.create :rating, beer_id: 1, score: 30, user_id: 1
        FactoryGirl.create :rating, beer_id: 2, score: 30, user_id: 1

        visit user_path(@user)
        expect{
          page.all('a', text: 'delete')[1].click
        }.to change{Rating.count}.from(2).to(1)
      end
    end

  end