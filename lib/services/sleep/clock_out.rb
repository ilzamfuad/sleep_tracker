# frozen_string_literal: true

module Services
  module Sleep
    class ClockOut <  ApplicationService
      def initialize(user_id)
        @time = Time.now
        @user_id = user_id
      end

      def call
        if user_record.blank?
          raise UserNotFoundError
        end

        record = records&.first
        if record.blank? || record.status == "inactive" || record.sleep_time > @time
          raise NoSleepRecordFoundError
        end

        record.wake_time = @time
        record.duration = record.wake_time - record.sleep_time
        record.status = "inactive"
        record.save!

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
