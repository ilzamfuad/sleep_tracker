class ApplicationController < ActionController::API
  rescue_from BaseError, with: :render_error

  after_action do
    ActiveRecord::Base.connection_pool.disconnect!
  end

  def render_response(resource, template, status: nil, params: nil, additional_metas: [])
    result = ResponseBuilder.new(
      resource,
      template,
      status: status,
      params: params,
      additional_metas: additional_metas
    ).result

    render json: result, status: status
  end

  def render_message(message, status: 200, additional_metas: [])
    result = MessageBuilder.new(message, status: status, additional_metas: additional_metas).result
    render json: result, status: status
  end

  def render_error(err, additional_metas: [])
    result = ErrorBuilder.new(err, additional_metas: additional_metas).result
    render json: result, status: err.status
  end
end
