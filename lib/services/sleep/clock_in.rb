# frozen_string_literal: true

module Services
  module Sleep
    class ClockIn <  ApplicationService
      def initialize(user_id)
        @time = Time.now
        @user_id = user_id
      end

      def call
        if user_record.blank?
          raise UserNotFoundError
        end

        record = records&.first
        if record && record.status == "active"
          raise AlreadyRecordSleepError
        end

        newRecord = SleepRecord.new(
          user_id: @user_id,
          sleep_time: @time,
          status: "active"
        )
        newRecord.save!

        @records.unshift(newRecord)
        @records
      end

      private

      def records
        @records ||= SleepRecord.get_record(@user_id).to_a
      end

      def user_record
        @user_record ||= User.find_by(id: @user_id)
      end
    end
  end
end
