class MoodService
  VALID_MOODS = %w[happy sad fear angry].freeze
  MOOD_PATTERN = /\b(happy|sad|fear|angry)\b/

  class << self
    def predict(text)
      if MindliftConfig.openai_api_key.present?
        begin
          return predict_with_openai(text)
        rescue StandardError => e
          Rails.logger.warn("OpenAI mood prediction failed, using heuristic: #{e.message}")
        end
      else
        Rails.logger.warn("OpenAI API key is empty, using heuristic mood detection")
      end
      predict_with_heuristic(text)
    end

    private

    def predict_with_openai(text)
      raw = OpenAiClient.chat_completion(
        [
          { role: "system", content: "You are a mood predictor. Reply with exactly one lowercase word: happy, sad, fear, or angry. No punctuation." },
          { role: "user", content: "Predict my mood from this diary entry: #{text}" }
        ],
        temperature: 0
      )
      mood = parse_mood(raw)
      raise "Unexpected OpenAI mood response: #{raw}" unless mood

      mood
    end

    def parse_mood(raw)
      return nil if raw.blank?

      normalized = raw.strip.downcase.gsub(/[^a-z]/, " ")
      match = MOOD_PATTERN.match(normalized)
      return match[1] if match
      return normalized if VALID_MOODS.include?(normalized)

      nil
    end

    def predict_with_heuristic(text)
      lower = text.downcase
      return "angry" if lower.match?(/\b(angry|mad|furious|annoyed|生气|愤怒|恼火)\b/)
      return "sad" if lower.match?(
        /\b(sad|lonely|depressed|cry|tears|terrible|miserable|bad|awful|horrible|upset|unhappy|down|难过|悲伤|孤独|沮丧)\b/
      ) || lower.match?(/\bfeeling\s+bad\b|\bnot\s+(?:doing\s+)?(?:well|good)\b/)
      return "fear" if lower.match?(/\b(fear|scared|anxious|worried|nervous|害怕|焦虑|担心|恐惧)\b/)
      return "happy" if lower.match?(/\b(happy|glad|joy|great|wonderful|good|开心|高兴|快乐)\b/)

      "happy"
    end
  end
end
