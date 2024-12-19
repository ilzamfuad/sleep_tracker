# frozen_string_literal: true

class MessageBuilder
  def initialize(message, status: 200, additional_metas: [])
    @message = message
    @status = status
    @additional_metas = additional_metas
  end

  def result
    build_message
  end

  private

  def build_message
    res = {}
    res[:message] = @message

    meta_builders = @additional_metas + [ MetaBuilder::HttpStatus.new(@status) ]
    res[:meta] = MetaBuilder.build_meta(builders: meta_builders)

    res.to_json
  end
end
