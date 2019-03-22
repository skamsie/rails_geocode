FactoryBot.define do
  factory :geocode do
    query { "query string" }
    latitude { 40.71423 }
    longitude { -73.9599 }
    address { "formatted address" }
  end
end
