require 'rails_helper'

RSpec.describe Services::UserFollow::List, type: :service do
  let(:user) { build_stubbed(:user) }
  let(:other_user) { build_stubbed(:user) }
  let(:follow) { build_stubbed(:follow, follower: user, followee: other_user, is_followed: true) }
  let(:sleep_record) { build_stubbed(:sleep_record, user: user) }
  let(:service) { described_class.new(user.id) }

  before do
    allow(User).to receive(:find_by).with(id: user.id).and_return(user)
    allow(Follow).to receive(:where).with(follower_id: user.id, is_followed: true).and_return([ follow ])
  end

  describe '#call' do
    context 'when user does not exist' do
      before do
        allow(User).to receive(:find_by).with(id: user.id).and_return(nil)
      end

      it 'raises UserNotFoundError' do
        expect { service.call }.to raise_error(UserNotFoundError)
      end
    end

    context 'when user exists but has no followees' do
      before do
        allow(Follow).to receive(:where).with(follower_id: user.id, is_followed: true).and_return([])
      end
      it 'returns an empty array' do
        expect(service.call).to eq([])
      end
    end

    context 'when user exists and has followees' do
      before do
        allow(SleepRecord).to receive(:list_records).with([ other_user.id ]).and_return([ sleep_record ])
      end

      it 'returns the sleep records of followed users' do
        expect(service.call).to eq([ sleep_record ])
      end
    end
  end
end
