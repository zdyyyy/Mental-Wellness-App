module MindliftConfig
  class << self
    def settings
      @settings ||= Rails.application.config_for(:mindlift).deep_symbolize_keys
    end

    def jwt_secret = settings[:jwt_secret]
    def jwt_expiration_ms = settings[:jwt_expiration_ms]
    def openai_api_key
      key = settings[:openai_api_key].to_s.strip
      # Common copy-paste mistake: sk-sk-proj-...
      key = key.sub(/\Ask-sk-/, "sk-") if key.start_with?("sk-sk-")
      key
    end
    def openai_base_url = settings[:openai_base_url]
    def rabbitmq = settings[:rabbitmq]
    def rabbitmq_enabled? = rabbitmq[:enabled]
  end
end
