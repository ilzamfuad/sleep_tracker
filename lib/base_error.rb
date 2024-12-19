class BaseError < StandardError
    attr_accessor :code, :field, :status

    def initialize(message = "Terjadi kesalahan pada sistem",  status = 500)
      @message = message
      @status = status
      super(message)
    end

    def errors
      Array.wrap(self)
    end

    def response
      { message: @message }
    end
end

class InvalidParameterError < BaseError
    def initialize(message = "Invalid parameter")
      super(message, 400)
    end
end

class UserNotFoundError < BaseError
    def initialize(message = "User Not Found")
      super(message, 404)
    end
end

class FollowSelfError < BaseError
    def initialize(message = "You can't follow yourself")
      super(message, 422)
    end
end

class UnfollowSelfError < BaseError
    def initialize(message = "You can't unfollow yourself")
      super(message, 422)
    end
end

class AlreadyFollowError < BaseError
    def initialize(message = "You already follow this user")
      super(message, 422)
    end
end

class AlreadyUnfollowError < BaseError
    def initialize(message = "You already unfollow this user")
      super(message, 422)
    end
end

class NotFollowError < BaseError
    def initialize(message = "You are not following this user")
      super(message, 422)
    end
end

class AlreadyRecordSleepError < BaseError
    def initialize(message = "You are already record your sleep")
      super(message, 422)
    end
end

class NoSleepRecordFoundError < BaseError
    def initialize(message = "You are not record your sleep yet")
      super(message, 422)
    end
end
