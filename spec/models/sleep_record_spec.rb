require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'class methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      # Create sleep records for the current user
      create_list(:sleep_record, 5, user: user, created_at: 2.days.ago, duration: 5000)
      create_list(:sleep_record, 10, user: user, created_at: 10.days.ago, duration: 4000)

      # Create sleep records for another user
      create_list(:sleep_record, 3, user: other_user, created_at: 1.week.ago, duration: 3000)
      create(:sleep_record, user: other_user, created_at: Date.today.beginning_of_week - 2.weeks, duration: 2000)
    end

    describe '.get_record' do
      it 'returns the most recent records for a user limited by LIMIT_TWO_WEEK' do
        records = SleepRecord.get_record(user.id)

        expect(records.count).to eq(SleepRecord::LIMIT_TWO_WEEK)
        expect(records).to all(have_attributes(user_id: user.id))
        expect(records.first.created_at).to be > records.last.created_at
      end
    end

    describe '.list_records' do
      it 'returns records from the previous week ordered by duration' do
        previous_week_start = Date.today.beginning_of_week - 1.week
        records = SleepRecord.list_records([ user.id, other_user.id ])

        expect(records).to all(have_attributes(created_at: (previous_week_start.beginning_of_day..Time.now)))
        expect(records.first.duration).to be >= records.last.duration
      end

      it 'filters records based on the provided user IDs' do
        records = SleepRecord.list_records([ other_user.id ])

        expect(records).to all(have_attributes(user_id: other_user.id))
      end
    end
  end
end
