# frozen_string_literal: true

module Services
  module UserFollow
    class Fetch <  ApplicationService
      def initialize(user_id)
        @user_id = user_id
      end

      def call
        record
      end

      private

      def record
        @record ||= User.find_by(id: @user_id)
      end
    end
  end
end
