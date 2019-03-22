class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    return unless user

    token = JsonWebToken.encode(user_id: user.id)
    decoded_token = JsonWebToken.decode(token)
    { token: token, expires_at: Time.at(decoded_token["exp"]) }
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by_email(email)
    return user if user&.authenticate(password)

    errors.add :user_authentication, "Invalid credentials"
    nil
  end
end
