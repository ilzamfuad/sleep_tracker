module Services
  class ApplicationService
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def call(*args, &block)
        new(*args, &block).call
      end
    end

    def call
      raise NotImplementedError, "You must implement the call method"
    end
  end
end
