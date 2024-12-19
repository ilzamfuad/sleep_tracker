module Form
  module User
    class UserSchema < Dry::Validation::Contract
      params do
        required(:id).value(:integer)
      end
    end

    class UserSleepList < Base
      self.schemas = [
        UserSchema.new
      ]
    end
  end
end
