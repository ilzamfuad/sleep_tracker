module Form
  class Base
    class << self
      attr_accessor :schemas
    end

    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def method_missing(method_name, *args)
      return params[method_name] if attributes.include? method_name.to_s

      super
    end

    def respond_to_missing?(method_name, *args)
      return true if attributes.include? method_name.to_s

      super
    end

    def check_violations!
      raise InvalidParameterError unless valid?
    end

    def valid?
      schemas.each do |schema|
        result = schema.call(params)
        return false unless result.success?
      end

      true
    end

    private

    def schemas
      self.class.schemas
    end

    def attributes
      @attributes ||= schemas.flat_map { |schema| schema.schema.key_map.map(&:name) }
    end
  end
end
