namespace :rabbitmq do
  desc "Declare MindLift exchange and mood queue"
  task setup: :environment do
    RabbitMqSetup.ensure_topology!
    puts "RabbitMQ topology ready."
  end

  desc "Consume mood.recorded messages and sync user mood"
  task listen: :environment do
    abort "RabbitMQ is disabled (MINDLIFT_RABBITMQ_ENABLED=false)" unless MindliftConfig.rabbitmq_enabled?

    RabbitMqSetup.ensure_topology!
    cfg = MindliftConfig.rabbitmq
    connection = Bunny.new(cfg[:url])
    connection.start
    channel = connection.create_channel
    queue = channel.queue(cfg[:mood_recorded_queue], durable: true)

    puts "Listening on #{cfg[:mood_recorded_queue]}..."
    queue.subscribe(block: true, manual_ack: true) do |delivery_info, _properties, body|
      message = JSON.parse(body, symbolize_names: true)
      MoodRecordedHandler.handle(message)
      channel.ack(delivery_info.delivery_tag)
    rescue StandardError => e
      Rails.logger.error("Mood consumer error: #{e.message}")
      channel.nack(delivery_info.delivery_tag, false, true)
    end
  end
end
