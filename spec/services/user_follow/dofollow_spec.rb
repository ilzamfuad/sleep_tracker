require 'rails_helper'

RSpec.describe Services::UserFollow::Dofollow, type: :service do
  let(:follower) { build_stubbed(:user) }
  let(:followee) { build_stubbed(:user) }
  let(:follow) { build_stubbed(:follow, follower: follower, followee: followee, is_followed: false) }
  let(:service) { described_class.new(follower.id, followee.id) }

  before do
    allow(User).to receive(:find_by).with(id: follower.id).and_return(follower)
    allow(User).to receive(:find_by).with(id: followee.id).and_return(followee)
    allow(Follow).to receive(:find_by).with(follower_id: follower.id, followee_id: followee.id).and_return(follow)
  end

  describe '#call' do
    context 'when follower_id is equal to followee_id' do
      let(:service) { described_class.new(follower.id, follower.id) }

      it 'raises FollowSelfError' do
        expect { service.call }.to raise_error(FollowSelfError)
      end
    end

    context 'when follower or followee does not exist' do
      let(:service) { described_class.new(0, followee.id) }

      before do
        allow(User).to receive(:find_by).with(id: 0).and_return(nil)
      end

      it 'raises UserNotFoundError' do
        expect { service.call }.to raise_error(UserNotFoundError)
      end
    end

    context 'when follow record does not exist' do
      before do
        allow(Follow).to receive(:find_by).with(follower_id: follower.id, followee_id: followee.id).and_return(nil)
        allow(Follow).to receive(:create!).and_return(true)
      end

      it 'creates a new follow record' do
        service.call
        expect(Follow).to have_received(:create!).with(follower_id: follower.id, followee_id: followee.id, is_followed: true)
      end
    end

    context 'when follow record exists and is already followed' do
      let(:follow) { build_stubbed(:follow, follower: follower, followee: followee, is_followed: true) }

      it 'raises AlreadyFollowError' do
        expect { service.call }.to raise_error(AlreadyFollowError)
      end
    end

    context 'when follow record exists and is not followed' do
      before do
        allow(follow).to receive(:update!).and_return(true)
      end

      it 'updates the follow record to be followed' do
        service.call
        expect(follow).to have_received(:update!).with(is_followed: true)
      end
    end
  end
end
