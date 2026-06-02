class ChatService
  SYSTEM_PROMPT = <<~PROMPT.freeze
    You are MindLift, a warm and concise mental wellness companion.
    Offer empathy, practical coping ideas, and gentle encouragement.
    Keep replies under 120 words unless the user asks for more.
    You are not a licensed therapist. If the user mentions self-harm, suicide, or danger,
    urge them to contact local emergency services or a crisis hotline immediately.
    Do not diagnose medical conditions.
  PROMPT

  class << self
    def send_message(username, message)
      user = User.find_by!(username: username)
      text = message.to_s.strip

      user.chat_messages.create!(role: "USER", content: text)

      reply = if OpenAiClient.configured?
                OpenAiClient.chat_completion(build_prompt(user))
              else
                fallback_reply(text)
              end

      user.chat_messages.create!(role: "ASSISTANT", content: reply)
      detected = MoodService.predict(text)
      MoodHistoryService.record(username, detected, "CHAT")

      { reply: reply, recent: load_recent(user) }
    end

    def history(username)
      user = User.find_by!(username: username)
      { messages: load_recent(user) }
    end

    private

    def load_recent(user)
      messages = user.chat_messages.order(created_at: :desc).limit(50).reverse
      messages.map { |m| message_item(m) }
    end

    def message_item(message)
      {
        role: message.role.downcase,
        content: message.content,
        createdAt: message.created_at.iso8601(3)
      }
    end

    def build_prompt(user)
      messages = [{ role: "system", content: SYSTEM_PROMPT }]
      if user.mood.present?
        messages << { role: "system", content: "The user's latest detected mood is: #{user.mood}" }
      end

      history = user.chat_messages.order(created_at: :desc).limit(20).reverse
      history.each do |msg|
        messages << {
          role: msg.role == "USER" ? "user" : "assistant",
          content: msg.content
        }
      end
      messages
    end

    def fallback_reply(message)
      lower = message.downcase
      if lower.include?("sad") || lower.include?("lonely") || lower.include?("难过")
        return "I hear that you're going through a heavy time. It might help to write a short diary entry and listen to something calming from your recommended music."
      end
      if lower.include?("anxious") || lower.include?("worried") || lower.include?("焦虑")
        return "Anxiety can feel overwhelming. Try a few slow breaths, then note what is on your mind in your diary."
      end
      "Thank you for sharing. I'm here with you. Consider journaling today and checking your mood trends to notice what helps you feel better."
    end
  end
end
