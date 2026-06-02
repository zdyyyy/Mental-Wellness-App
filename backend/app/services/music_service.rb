class MusicService
  MOOD_TO_GENRE_NAMES = {
    "happy" => ["Classical"],
    "sad" => ["Hip Hop"],
    "fear" => ["Country"],
    "angry" => ["Electronic"]
  }.freeze

  class << self
    def list_genres
      Genre.all.map { |g| genre_json(g) }
    end

    def list_songs(genre_id)
      genre = Genre.find(genre_id)
      genre.songs.map { |s| song_json(s) }
    end

    def get_song(song_id)
      song_json(Song.find(song_id))
    end

    def recommendations(username)
      user = User.find_by!(username: username)
      mood = resolve_current_mood(user)
      return { mood: nil, recommendedGenres: [] } if mood.blank?

      names = MOOD_TO_GENRE_NAMES[mood] || []
      genres = Genre.where(name: names).map { |g| genre_json(g) }
      { mood: mood, recommendedGenres: genres }
    end

    def resolve_current_mood(user)
      mood = user.mood&.strip&.downcase
      return mood if mood.present?

      latest = user.mood_entries.order(recorded_at: :desc).first
      return nil unless latest

      mood = latest.mood.downcase
      user.update!(mood: mood) if user.mood.blank?
      mood
    end

    private

    def genre_json(genre)
      { id: genre.id, name: genre.name, coverUrl: genre.cover_url }
    end

    def song_json(song)
      {
        id: song.id,
        title: song.title,
        artist: song.artist,
        genreId: song.genre_id,
        url: song.url,
        coverUrl: song.cover_url
      }
    end
  end
end
