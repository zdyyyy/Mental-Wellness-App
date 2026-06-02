require "bunny"

class MoodRabbitPublisher
  class << self
    def publish(message)
      cfg = MindliftConfig.rabbitmq
      connection = Bunny.new(cfg[:url])
      connection.start
      channel = connection.create_channel
      exchange = channel.topic(cfg[:exchange], durable: true)
      exchange.publish(
        message.to_json,
        routing_key: cfg[:mood_recorded_routing_key],
        content_type: "application/json"
      )
    ensure
      connection&.close
    end
  end
end
