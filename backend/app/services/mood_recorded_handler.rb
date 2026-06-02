class MoodRecordedHandler
  class << self
    def handle(message)
      user = User.find_by(username: message[:username])
      return unless user

      user.update!(mood: message[:mood])
      entry_id = message[:entryId] || message["entryId"]
      Rails.logger.info(
        "Synced user mood from #{message[:source]} (entryId=#{entry_id}, mood=#{message[:mood]})"
      )
    end
  end
end
