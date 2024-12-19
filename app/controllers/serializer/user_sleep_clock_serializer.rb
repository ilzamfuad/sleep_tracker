# frozen_string_literal: true

module Serializer
  class UserSleepClockSerializer < BaseSerializer
    attribute :user_id
    attribute :sleep_time
    attribute :wake_time
    attribute :duration
    attribute :status
  end
end
