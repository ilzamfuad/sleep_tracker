# frozen_string_literal: true

module Services
  module UserFollow
    class Dofollow <  ApplicationService
      def initialize(follower_id, followee_id)
        @follower_id = follower_id
        @followee_id = followee_id
      end

      def call
        if @follower_id == @followee_id
          raise FollowSelfError
        end

        if follower_record.blank? || followee_record.blank?
          raise UserNotFoundError
        end

        if follow_record.nil?
          Follow.create!(follower_id: @follower_id, followee_id: @followee_id, is_followed: true)
        else
          if follow_record.is_followed
            raise AlreadyFollowError
          else
            follow_record.update!(is_followed: true)
          end
        end
      end

      private

      def follower_record
        @follower_record ||= User.find_by(id: @follower_id)
      end

      def followee_record
        @followee_record ||= User.find_by(id: @followee_id)
      end

      def follow_record
        @follow_record ||= Follow.find_by(follower_id: @follower_id, followee_id: @followee_id)
      end
    end
  end
end
