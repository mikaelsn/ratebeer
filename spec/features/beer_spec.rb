require 'spec_helper'
include OwnTestHelper

describe "Beer" do

  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create(:brewery)
    visit new_beer_path
  end

  it "can be created with a valid name" do
    fill_in('beer[name]', with:'Bisse')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "can not be created without a valid name" do
    fill_in('beer[name]', with:'')

    expect{
      click_button "Create Beer"
    }.not_to change{Beer.count}.from(0).to(1)

    expect(page).to have_content "Name can't be blank"
  end
end