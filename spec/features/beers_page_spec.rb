require 'rails_helper'

describe "A new beer" do
  before :each do
    FactoryBot.create(:brewery, name: 'Testbrewery', year: 2000)
    visit new_beer_path
  end
  it "can be added with a valid name" do
    fill_in('beer_name', with: 'Koff')
    select('IPA', from: 'beer_style')
    select('Testbrewery', from: 'beer_brewery_id')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "can not be added if name is not given" do
    select('IPA', from: 'beer_style')
    select('Testbrewery', from: 'beer_brewery_id')

    expect {
      click_button('Create Beer')
    }.not_to change { Beer.count }
    save_and_open_page
    expect(page).to have_content "Name can't be blank"
  end
end