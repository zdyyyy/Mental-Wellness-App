require "bunny"

class RabbitMqSetup
  class << self
    def ensure_topology!
      return unless MindliftConfig.rabbitmq_enabled?

      cfg = MindliftConfig.rabbitmq
      connection = Bunny.new(cfg[:url])
      connection.start
      channel = connection.create_channel
      exchange = channel.topic(cfg[:exchange], durable: true)
      queue = channel.queue(cfg[:mood_recorded_queue], durable: true)
      queue.bind(exchange, routing_key: cfg[:mood_recorded_routing_key])
    ensure
      connection&.close
    end
  end
end
