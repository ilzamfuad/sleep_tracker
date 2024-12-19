# frozen_string_literal: true

module MetaBuilder
  class HttpStatus < Base
    extend ::Dry::Initializer

    param :status

    def gen_meta
      { http_status: status }
    end
  end
end
