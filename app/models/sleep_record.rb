class SleepRecord < ApplicationRecord
  belongs_to :user

  LIMIT_TWO_WEEK = 15.freeze

  def self.get_record(user_id)
    where(user_id: user_id).order(created_at: :desc).limit(LIMIT_TWO_WEEK)
  end
end
