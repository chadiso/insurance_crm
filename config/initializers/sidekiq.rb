require 'sidekiq'
require 'sidekiq-status'

redis_options = {
  url: ENV['REDIS_URL'],
  namespace: "#{Rails.application.class.to_s.deconstantize.underscore}_#{Rails.env}#{ENV.fetch('TEST_ENV_NUMBER', '')}"
}

# Sidekiq status configuration
Sidekiq.configure_client do |config|
  config.redis = redis_options
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes
  end
end

Sidekiq.configure_server do |config|
  config.redis = redis_options
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes
  end
end
