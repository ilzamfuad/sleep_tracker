class User < ApplicationRecord
  has_many :followers, foreign_key: :follower_id, class_name: "Follow"
  has_many :followees, foreign_key: :followee_id, class_name: "Follow"

  has_many :sleep_trackers
end
