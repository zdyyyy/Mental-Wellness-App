class MoodEventPublisher
  class << self
    def publish_after_save(message)
      return unless MindliftConfig.rabbitmq_enabled?

      MoodRabbitPublisher.publish(message)
    rescue StandardError => e
      Rails.logger.warn("RabbitMQ publish skipped: #{e.message}")
    end
  end
end
