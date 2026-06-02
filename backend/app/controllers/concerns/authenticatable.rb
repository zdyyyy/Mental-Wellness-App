module Authenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_username
  end

  def authenticate_user!
    header = request.headers["Authorization"].to_s
    token = header.delete_prefix("Bearer ").strip
    username = JwtService.decode(token)
    unless username
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
    @current_username = username
  end
end
