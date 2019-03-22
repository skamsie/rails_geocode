require "http"

class GeocodeController < ApplicationController
  before_action :parse_params

  def index
    if cached_data.blank? || @cache == "false"
      result = JSON.parse(google_data)

      unless result["status"] == "OK"
        return handle_error("Could not compute coordinates for this address")
      end

      Geocode.where(query: @address)
        .first_or_create
        .update_attributes(geocode_data(result))
    end
    render json: cached_data.attributes.except("id")
  rescue JSON::ParserError
    handle_error("Unknown Error")
  end

  private

  def google_data
    HTTP.get(
      "https://maps.googleapis.com/maps/api/geocode/json",
      params: { key: ENV["GOOGLE_API_KEY"], address: @address }
    )
  end

  def parse_params
    @address = params["address"].to_s.downcase
    @cache = params["cache"]

    return handle_error("'address' is mandatory") unless @address.present?
  end

  def cached_data
    Geocode.find_by(query: @address)
  end

  def geocode_data(response_body)
    result = response_body["results"][0]
    {
      query: @address,
      address: result["formatted_address"],
      latitude: result["geometry"]["location"]["lat"],
      longitude: result["geometry"]["location"]["lng"]
    }
  end

  def handle_error(message)
    render json: { error: message }, status: 422
  end
end
