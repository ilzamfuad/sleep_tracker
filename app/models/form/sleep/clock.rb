module Form
  module Sleep
    class SleepSchema < Dry::Validation::Contract
      json do
        required(:user_id).filled(:integer)
      end
    end

    class Clock < Base
      self.schemas = [
        SleepSchema.new
      ]
    end
  end
end
