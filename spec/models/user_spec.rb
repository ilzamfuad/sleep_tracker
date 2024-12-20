require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:followers).with_foreign_key(:follower_id).class_name('Follow') }
    it { should have_many(:followees).with_foreign_key(:followee_id).class_name('Follow') }
    it { should have_many(:sleep_records) }
  end
end
