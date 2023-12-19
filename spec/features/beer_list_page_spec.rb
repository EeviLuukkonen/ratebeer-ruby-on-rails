require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new app, browser: :chrome,
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    end
  
    Capybara.javascript_driver = :chrome
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:"Lager")
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:"Rauchbier")
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:"Weizen")
  end

  it "shows a known beer", :js => true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "by default shows beers in alphabetical order by beer name", js:true do
    visit beerlist_path
    first = find('#beertable').first('.tablerow')
    second = find('#beertable').all('.tablerow')[1]
    third = find('#beertable').all('.tablerow')[2]
    expect(first).to have_content "Fastenbier"
    expect(second).to have_content "Lechte Weisse"
    expect(third).to have_content "Nikolai"
  end

  it "when style is clicked shows beers in alphabetical order by style name", js:true do
    visit beerlist_path
    find_by_id("style").click
    first = find('#beertable').first('.tablerow')
    second = find('#beertable').all('.tablerow')[1]
    third = find('#beertable').all('.tablerow')[2]
    expect(first).to have_content "Nikolai"
    expect(second).to have_content "Fastenbier"
    expect(third).to have_content "Lechte Weisse"
  end

  it "when brewery is clicked shows beers in alphabetical order by style name", js:true do
    visit beerlist_path
    find_by_id("brewery").click
    first = find('#beertable').first('.tablerow')
    second = find('#beertable').all('.tablerow')[1]
    third = find('#beertable').all('.tablerow')[2]
    expect(first).to have_content "Lechte Weisse"
    expect(second).to have_content "Nikolai"
    expect(third).to have_content "Fastenbier"
  end
end