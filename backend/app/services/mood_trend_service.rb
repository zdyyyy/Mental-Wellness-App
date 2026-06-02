class MoodTrendService
  VALID_MOODS = %w[happy sad fear angry].freeze
  MOOD_PATTERN = /\b(happy|sad|fear|angry)\b/

  class << self
    def trend(username, days)
      user = User.find_by!(username: username)
      since = days.days.ago
      entries = user.mood_entries.where(recorded_at: since..).order(:recorded_at)

      history = entries.map do |e|
        { recordedAt: e.recorded_at.iso8601(3), mood: e.mood, source: e.source }
      end
      counts = entries.group(:mood).count
      current = user.mood.presence || entries.last&.mood
      { history: history, counts: counts, currentMood: current }
    end

    def predict(username)
      user = User.find_by!(username: username)
      recent = user.mood_entries.order(recorded_at: :desc).limit(30).sort_by(&:recorded_at)

      if recent.empty?
        return {
          predictedMood: "happy",
          insight: "Write a few diary entries first so we can learn your mood patterns.",
          usedAi: false
        }
      end

      if OpenAiClient.configured?
        begin
          return predict_with_ai(recent)
        rescue StandardError
          # fall through
        end
      end

      predict_with_heuristic(recent)
    end

    private

    def predict_with_ai(recent)
      timeline = recent.map { |e| "#{e.recorded_at.to_date}:#{e.mood}" }.join(", ")
      raw = OpenAiClient.chat_completion(
        [
          {
            role: "system",
            content: "You analyze mood timelines for a wellness app. Reply in two lines. Line 1: exactly one mood word (happy, sad, fear, or angry) predicting the user's likely mood tomorrow. Line 2: one short supportive sentence (max 20 words)."
          },
          { role: "user", content: "Mood history (oldest to newest): #{timeline}" }
        ]
      )

      lines = raw.split(/\R/, 2)
      mood = parse_mood(lines[0]) || predict_with_heuristic(recent)[:predictedMood]
      insight = lines[1]&.strip.presence || "Based on your recent entries, keep taking small mindful steps."
      { predictedMood: mood, insight: insight, usedAi: true }
    end

    def predict_with_heuristic(recent)
      weights = Hash.new(0)
      recent.each_with_index do |entry, index|
        weights[entry.mood] += index + 1
      end

      predicted = weights.max_by { |_, v| v }&.first || "happy"
      happy = weights["happy"]
      sad = weights["sad"]
      fear = weights["fear"]
      angry = weights["angry"]

      insight = if sad + fear > happy + angry
                  "Recent entries lean reflective or heavy. Consider calm music and a short diary tonight."
                elsif angry > happy
                  "Tension showed up recently. A walk or breathing break may help before tomorrow."
                else
                  "Your recent pattern looks relatively steady. Keep your journaling rhythm going."
                end

      { predictedMood: predicted, insight: insight, usedAi: false }
    end

    def parse_mood(raw)
      return nil if raw.blank?

      match = MOOD_PATTERN.match(raw.downcase)
      return match[1] if match

      trimmed = raw.strip.downcase
      VALID_MOODS.include?(trimmed) ? trimmed : nil
    end
  end
end
