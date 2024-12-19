# frozen_string_literal: true

module MetaBuilder
  class Pagination < Base
    extend ::Dry::Initializer

    param :args
    param :resources

    def gen_meta
      return {} unless resources.is_a? Array

      resources_count = resources.count
      offset = args&.dig(:offset) || 0
      limit =  args&.dig(:limit) || resources_count
      total =  args&.dig(:total) || resources_count

      {
        offset: offset,
        limit: limit,
        total: total
      }
    end
  end
end
