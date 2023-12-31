require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    allow(WeatherstackApi).to receive(:get_weather_in).with("kumpula").and_return(
      Weather.new( temperature: 2, weather_icons: [] )
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

    allow(WeatherstackApi).to receive(:get_weather_in).with("mikkeli").and_return(
      Weather.new( temperature: 2, weather_icons: [] )
    )

    visit places_path
    fill_in('city', with: 'mikkeli')
    click_button "Search"
    

    expect(page).to have_content "Jälkipeli"
    expect(page).to have_content "Wilhelm"
  end

  it "if none are returned by the API, it shows a notification about it" do
    allow(BeermappingApi).to receive(:places_in).with("notaplace").and_return(
      []
    )

    allow(WeatherstackApi).to receive(:get_weather_in).with("notaplace").and_return(nil)

    visit places_path
    fill_in('city', with: 'notaplace')
    click_button "Search"

    expect(page).to have_content "No locations in notaplace"
  end
end