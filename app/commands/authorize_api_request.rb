class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)

    if @decoded_auth_token.blank?
      errors.add(:token, "Token invalid or expired")
      return nil
    end

    @decoded_auth_token
  end

  def http_auth_header
    return unless headers["Authorization"].present?

    headers["Authorization"].split(" ").last
  end
end
