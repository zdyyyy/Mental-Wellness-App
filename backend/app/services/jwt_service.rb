class JwtService
  class << self
    def encode(username)
      payload = {
        sub: username,
        iat: Time.now.to_i,
        exp: (Time.now.to_i + (MindliftConfig.jwt_expiration_ms / 1000))
      }
      JWT.encode(payload, secret, "HS256")
    end

    def decode(token)
      body, = JWT.decode(token, secret, true, algorithm: "HS256")
      body["sub"]
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end

    def valid?(token)
      decode(token).present?
    end

    private

    def secret
      MindliftConfig.jwt_secret
    end
  end
end
