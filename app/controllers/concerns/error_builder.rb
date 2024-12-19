# frozen_string_literal: true

class ErrorBuilder
  def initialize(err, additional_metas: [])
    @err = err
    @additional_metas = additional_metas
  end

  def result
    return build_response_error if @err.is_a? BaseError

    raise NotImplementedError
  end

  private

  def build_response_error
    build_error(@err, @err.status)
  end

  def build_error(err, status)
    res = { errors: Array.wrap(err.response) }
    meta_builders = @additional_metas + [ MetaBuilder::HttpStatus.new(status) ]
    res[:meta] = MetaBuilder.build_meta(builders: meta_builders)

    res.to_json
  end
end
