json.extract! brewery, :id, :name, :year, :created_at, :updated_at, :active, :beers
json.url brewery_url(brewery, format: :json)
