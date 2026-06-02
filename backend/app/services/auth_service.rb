class AuthService
  class ApiError < StandardError
    attr_reader :status

    def initialize(status, message)
      @status = status
      super(message)
    end
  end

  class << self
    def signup(params)
      if User.exists?(username: params[:username])
        raise ApiError.new(:conflict, "Username already exists")
      end

      user = User.create!(
        username: params[:username],
        password: params[:password],
        first_name: params[:firstName],
        last_name: params[:lastName],
        email: params[:email]
      )
      auth_response(user)
    end

    def login(params)
      user = User.find_by(username: params[:username])
      unless user&.authenticate(params[:password])
        raise ApiError.new(:unauthorized, "Invalid username or password")
      end
      auth_response(user)
    end

    def profile(username)
      user = User.find_by!(username: username)
      {
        username: user.username,
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        mood: user.mood
      }
    end

    private

    def auth_response(user)
      {
        token: JwtService.encode(user.username),
        username: user.username,
        firstName: user.first_name,
        lastName: user.last_name,
        mood: user.mood
      }
    end
  end
end
