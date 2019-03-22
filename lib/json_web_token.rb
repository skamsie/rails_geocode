class JsonWebToken
  class << self
    def encode(payload, exp = 2.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret, "HS256")
    end

    def decode(token)
      body = JWT.decode(token, secret, true, algorithm: "HS256")[0]
      HashWithIndifferentAccess.new(body)
    rescue StandardError
      nil
    end

    def secret
      ENV["JWT_SECRET"]
    end
  end
end
