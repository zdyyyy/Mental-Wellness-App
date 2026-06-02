require "net/http"
require "json"

class OpenAiClient
  class << self
    def configured?
      MindliftConfig.openai_api_key.present?
    end

    def chat_completion(messages, temperature: 0.7)
      uri = URI("#{MindliftConfig.openai_base_url}/chat/completions")
      body = {
        model: "gpt-4o-mini",
        temperature: temperature,
        messages: messages
      }

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        request = Net::HTTP::Post.new(uri)
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer #{MindliftConfig.openai_api_key}"
        request.body = JSON.generate(body)
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise "HTTP #{response.code}: #{response.body}"
      end

      JSON.parse(response.body).dig("choices", 0, "message", "content").to_s.strip
    end
  end
end
