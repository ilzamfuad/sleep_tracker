# frozen_string_literal: true

module Serializer
  class BaseSerializer < SimpleDelegator
    Attr = Struct.new(:name, :key)

    class << self
      def attribute(name, key: nil)
        attr = Attr.new(name, key)
        attributes << attr
      end

      def attributes
        @attributes ||= []
      end
    end

    def object
      __getobj__
    end

    def hash_attributes
      result = {}
      self.class.attributes.each do |attr|
        key = attr.key
        key ||= attr.name

        value = send(attr.name)
        value = value.hash_attributes if value.is_a? BaseSerializer

        result[key] = value
      end

      result
    end
  end
end
