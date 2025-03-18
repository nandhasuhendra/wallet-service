class ApplicationWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3, queue: 'default'

  sidekiq_retries_exhausted do |msg, ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform
    raise NotImplementedError
  end
end
