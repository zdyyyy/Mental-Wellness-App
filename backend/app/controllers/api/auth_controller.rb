module Api
  class AuthController < ApplicationController
    skip_before_action :authenticate_user!, raise: false

    def signup
      result = AuthService.signup(signup_params)
      render_json(result, status: :created)
    end

    def login
      result = AuthService.login(login_params)
      render_json(result)
    end

    def me
      authenticate_user!
      return if performed?

      render_json(AuthService.profile(current_username))
    end

    private

    def signup_params
      params.permit(:firstName, :lastName, :email, :username, :password).to_h.symbolize_keys
    end

    def login_params
      params.permit(:username, :password).to_h.symbolize_keys
    end
  end
end
