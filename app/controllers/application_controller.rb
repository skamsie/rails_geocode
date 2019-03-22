class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers)
    unless @current_user.result
      render(
        json: { error: "Not Authorized" }.merge!(@current_user.errors),
        status: 401
      )
    end
  end
end
