module Form
  module User
    class UserFollowSchema < Dry::Validation::Contract
      json do
        required(:follower_id).value(:integer)
        required(:followee_id).value(:integer)
      end
    end

    class UserFollow < Base
      self.schemas = [
        UserFollowSchema.new
      ]
    end
  end
end
