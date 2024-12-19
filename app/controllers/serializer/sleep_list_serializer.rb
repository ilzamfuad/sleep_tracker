# frozen_string_literal: true

module Serializer
  class SleepListSerializer < BaseSerializer
    attribute :user_id
    attribute :sleep_time
    attribute :wake_time
    attribute :duration
    attribute :status
    attribute :username

    def username
      object.user.name
    end
  end
end
