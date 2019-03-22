require "rack/test"
require "webmock/rspec"
require "factory_bot"

module RSpecMixin
  include Rack::Test::Methods

  def response_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!

  WebMock.disable_net_connect!(allow_localhost: true)

  config.include FactoryBot::Syntax::Methods
  config.include RSpecMixin

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  def stub_google_geocode_request(address, lat, lng, status = "OK", mal = false)
    st = stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json")
      .with(
        query: {
          address: address.to_s.downcase,
          key: ENV["GOOGLE_API_KEY"]
        })
    unless mal
      return st.to_return(
        status: 200,
        body: {
          status: status,
          results: [
            {
              "formatted_address": "formatted address",
              "geometry": { "location": { "lat": lat, "lng": lng } }
            }
          ]
        }.to_json)
    end

    st.to_return(status: 403, body: "")
  end
end
