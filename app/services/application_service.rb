class ApplicationService
  def self.call(**args)
    new(**args).call
  end

  def call
    raise NotImplementedError
  end

  private

  ResultSuccess = Struct.new(:success?, :data, :errors)
  ResultFailure = Struct.new(:success?, :data, :errors)

  def handler_success(data)
    ResultSuccess.new(true, data, nil)
  end

  def handler_failure(errors)
    ResultFailure.new(false, nil, errors)
  end
end
