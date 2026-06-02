class ApplicationController < ActionController::API
  include Authenticatable

  rescue_from AuthService::ApiError, with: :render_api_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_json(data, status: :ok)
    render json: JsonCamelizer.camelize(data), status: status
  end

  def render_api_error(error)
    render json: { error: error.message }, status: error.status
  end

  def render_not_found(_error)
    render json: { error: "Not found" }, status: :not_found
  end

  def render_validation_error(message)
    render json: { error: message }, status: :bad_request
  end
end
