class SleepRecord < ApplicationRecord
  belongs_to :user

  LIMIT_TWO_WEEK = 15.freeze

  def self.get_record(user_id)
    where(user_id: user_id).order(created_at: :desc).limit(LIMIT_TWO_WEEK)
  end

  def self.list_records(user_ids)
    previous_week_start = Date.today.beginning_of_week - 1.week
    where(user_id: user_ids).where(created_at: previous_week_start.beginning_of_day..Time.now).order(duration: :desc)
  end
end
