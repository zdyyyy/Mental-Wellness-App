module Api
  class MusicController < ApplicationController
    before_action :authenticate_user!, except: %i[genres songs song]

    def genres
      render_json(MusicService.list_genres)
    end

    def recommendations
      render_json(MusicService.recommendations(current_username))
    end

    def songs
      render_json(MusicService.list_songs(params[:genre_id]))
    end

    def song
      render_json(MusicService.get_song(params[:song_id]))
    end
  end
end
