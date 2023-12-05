require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if more than one is returned by the API, all of them are shown" do
    allow(BeermappingApi).to receive(:places_in).with("mikkeli").and_return(
      [ Place.new( name: "Jälkipeli", id: 1 ),
        Place.new( name: "Wilhelm", id: 2 ) ],
    )

    visit places_path
    fill_in('city', with: 'mikkeli')
    click_button "Search"
    

    expect(page).to have_content "Jälkipeli"
    expect(page).to have_content "Wilhelm"
  end

  it "if none are returned by the API, it shows a notification about it" do
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"
    save_and_open_page

    expect(page).to have_content "No locations in kumpula"
  end
end