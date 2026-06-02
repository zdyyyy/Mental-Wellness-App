if MindliftConfig.rabbitmq_enabled?
  Rails.application.config.after_initialize do
    begin
      RabbitMqSetup.ensure_topology!
    rescue StandardError => e
      Rails.logger.warn("RabbitMQ setup skipped: #{e.message}")
    end
  end
end
