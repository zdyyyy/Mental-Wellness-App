module Api
  class DiaryController < ApplicationController
    before_action :authenticate_user!

    def create
      text = params.require(:text)
      render_json(DiaryService.append(current_username, text))
    end

    def show
      date = Date.parse(params.require(:date))
      render_json(DiaryService.get_entry(current_username, date))
    end
  end
end
