module Api
  class MoodController < ApplicationController
    before_action :authenticate_user!

    def trend
      days = [params.fetch(:days, 30).to_i, 90].min
      render_json(MoodTrendService.trend(current_username, days))
    end

    def predict
      render_json(MoodTrendService.predict(current_username))
    end
  end
end
