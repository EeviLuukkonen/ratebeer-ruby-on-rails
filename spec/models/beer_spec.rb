require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:brewery){ Brewery.create name: "Koff", year: "1890" }
  it "is saved if all fields are valid" do
    beer = Beer.create name: "Lager", style: "Lager", brewery_id: brewery.id

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  describe "is not saved" do
    it "if name is missing" do
      beer = Beer.create style: "Lager", brewery_id: brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)      
    end

    it "if style is missing" do
      beer = Beer.create name: "Lager", brewery_id: brewery.id

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0) 
    end
  end
end
