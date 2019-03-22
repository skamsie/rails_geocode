require_relative "../rails_helper"

RSpec.describe GeocodeController do
  describe "#index" do
    context "unauthenticated user" do
      before { get :index }

      it "returns unauthentication error" do
        expect(response_body).to eq(
          "error" => "Not Authorized", "token" => ["Token invalid or expired"]
        )
      end
    end

    context "authenticated user" do
      let(:address) { URI.encode("Ohlauer Str. 38, Berlin") }

      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:authenticate_request)
          .and_return(true)
      end

      context "when there is no cached data" do
        context "when google response has results" do
          before do
            stub_google_geocode_request(address, 40.22, -73.22)
            get :index, params: { address: address }
          end

          it "creates an entry in the Geocode table" do
            expect(Geocode.all.count).to eq(1)
            expect(Geocode.first.query).to eq(address.to_s.downcase)
          end

          it "has status code 200" do
            expect(response.status).to eq(200)
          end

          it "returns the correct response" do
            expect(response_body).to eq(
              "address" => "formatted address",
              "latitude" => "40.22",
              "longitude" => "-73.22",
              "query" => "ohlauer%20str.%2038,%20berlin"
            )
          end
        end

        context "when the address param is not passed" do
          before { get :index }

          it "has status code 422" do
            expect(response.status).to eq(422)
          end

          it "has 'address is mandatory' error" do
            expect(response_body).to eq("error" => "'address' is mandatory")
          end
        end

        context "when google response has no results" do
          before do
            stub_google_geocode_request(
              address, 40.22, -73.22, "ZERO RESULTS", false)
            get :index, params: { address: address }
          end

          it "has status code 422" do
            expect(response.status).to eq(422)
          end

          it "returns 'could not compute' error" do
            expect(response_body).to eq(
              "error" => "Could not compute coordinates for this address"
            )
          end
        end

        context "when google response is malformed" do
          before do
            stub_google_geocode_request(
              address, 40.22, -73.22, "ZERO RESULTS", true)
            get :index, params: { address: address }
          end

          it "has status code 422" do
            expect(response.status).to eq(422)
          end

          it "returns unknown error" do
            expect(response_body).to eq("error" => "Unknown Error")
          end
        end
      end

      context "when there is cached data for this address" do
        let!(:cached_data) do
          create(
            :geocode,
            query: address.downcase, latitude: 33.333, longitude: 1.22
          )
        end

        before do
          stub_google_geocode_request(address, 40.22, -73.22)
        end

        context "'cache' parameter is not passed" do
          before { get :index, params: { address: address } }

          it "returns data from cache not from google" do
            expect(response_body).to eq(
              "address" => "formatted address",
              "latitude" => "33.333",
              "longitude" => "1.22",
              "query" => "ohlauer%20str.%2038,%20berlin"
            )
          end
        end

        context "'cache' parameter is passed as false" do
          before { get :index, params: { address: address, cache: false } }

          it "returns data from updated cache" do
            expect(response_body).to eq(
              "address" => "formatted address",
              "latitude" => "40.22",
              "longitude" => "-73.22",
              "query" => "ohlauer%20str.%2038,%20berlin"
            )
          end
        end
      end
    end
  end
end
