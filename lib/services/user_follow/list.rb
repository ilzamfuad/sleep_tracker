# frozen_string_literal: true

module Services
  module UserFollow
    class List <  ApplicationService
      def initialize(id)
        @id = id
      end

      def call
        if user_record.blank?
          raise UserNotFoundError
        end

        if followee_record_ids.blank?
          return []
        end

        list_sleep_records
      end

      private

      def user_record
        @record ||= User.find_by(id: @id)
      end

      def followee_record_ids
        @follow_record ||= Follow.where(follower_id: @id, is_followed: true).pluck(:followee_id)
      end

      def list_sleep_records
        @list_sleep_records ||= SleepRecord.list_records(followee_record_ids).to_a
      end
    end
  end
end
