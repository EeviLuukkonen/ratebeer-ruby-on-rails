require 'rails_helper'

include Helpers

describe "A new beer" do
  before :each do
    FactoryBot.create :brewery, name: 'Testbrewery', year: 2000
    FactoryBot.create :user
    sign_in(username: "Pekka", password: "Foobar1")
    visit new_beer_path
  end
  it "can be added with a valid name" do
    fill_in('beer_name', with: 'Koff')
    select('IPA', from: 'beer_style')
    select('Testbrewery', from: 'beer_brewery_id')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
    expect(page).to have_content 'Beer was successfully created.'
  end

  it "can not be added if name is not given" do
    select('IPA', from: 'beer_style')
    select('Testbrewery', from: 'beer_brewery_id')

    expect {
      click_button('Create Beer')
    }.not_to change { Beer.count }
    
    expect(page).to have_content "Name can't be blank"
  end
end