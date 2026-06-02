class MoodHistoryService
  class << self
    def record(username, mood, source)
      user = User.find_by!(username: username)
      entry = user.mood_entries.create!(mood: mood, source: source.to_s.upcase)

      message = {
        entryId: entry.id,
        username: username,
        mood: mood,
        source: entry.source,
        recordedAt: entry.recorded_at.iso8601(3)
      }
      # Always update profile mood (music recommendations, home badge).
      # RabbitMQ consumer duplicates this when the broker is running.
      MoodRecordedHandler.handle(message)
      MoodEventPublisher.publish_after_save(message)
    end
  end
end
