class DiaryService
  class << self
    def append(username, text)
      user = User.find_by!(username: username)
      today = Date.current
      entry = DiaryEntry.find_or_initialize_by(user: user, entry_date: today)
      entry.content = "" if entry.content.blank? && entry.new_record?

      entry.content = if entry.content.blank?
                        text
                      else
                        "#{entry.content}\n#{text}"
                      end
      entry.save!

      mood = MoodService.predict(text)
      MoodHistoryService.record(username, mood, "DIARY")
      { mood: mood }
    end

    def get_entry(username, date)
      user = User.find_by!(username: username)
      entry = DiaryEntry.find_by(user: user, entry_date: date)
      content = entry&.content.presence || "No diary notes on #{date}"
      { date: date.iso8601, content: content }
    end
  end
end
