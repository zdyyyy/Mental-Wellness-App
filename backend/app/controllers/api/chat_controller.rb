module Api
  class ChatController < ApplicationController
    before_action :authenticate_user!

    def history
      render_json(ChatService.history(current_username))
    end

    def create
      message = params.require(:message)
      render_json(ChatService.send_message(current_username, message))
    end
  end
end
