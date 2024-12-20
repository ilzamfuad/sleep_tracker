require 'rails_helper'

RSpec.describe Services::UserFollow::Unfollow, type: :service do
  let(:follower) { build_stubbed(:user) }
  let(:followee) { build_stubbed(:user) }
  let(:follow) { build_stubbed(:follow, follower: follower, followee: followee, is_followed: true) }
  let(:service) { described_class.new(follower.id, followee.id) }

  before do
    allow(User).to receive(:find_by).with(id: follower.id).and_return(follower)
    allow(User).to receive(:find_by).with(id: followee.id).and_return(followee)
    allow(Follow).to receive(:find_by).with(follower_id: follower.id, followee_id: followee.id).and_return(follow)
  end

  describe '#call' do
    context 'when follower and followee are the same user' do
      let(:service) { described_class.new(follower.id, follower.id) }

      it 'raises UnfollowSelfError' do
        expect { service.call }.to raise_error(UnfollowSelfError)
      end
    end

    context 'when follower does not exist' do
      before do
        allow(User).to receive(:find_by).with(id: follower.id).and_return(nil)
      end

      it 'raises UserNotFoundError' do
        expect { service.call }.to raise_error(UserNotFoundError)
      end
    end

    context 'when followee does not exist' do
      before do
        allow(User).to receive(:find_by).with(id: followee.id).and_return(nil)
      end

      it 'raises UserNotFoundError' do
        expect { service.call }.to raise_error(UserNotFoundError)
      end
    end

    context 'when follow record does not exist' do
      before do
        allow(Follow).to receive(:find_by).with(follower_id: follower.id, followee_id: followee.id).and_return(nil)
      end

      it 'raises NotFollowError' do
        expect { service.call }.to raise_error(NotFollowError)
      end
    end

    context 'when follow record exists and is followed' do
      before do
        allow(follow).to receive(:update!).and_return(true)
      end

      it 'unfollows the user' do
        service.call
        expect(follow).to have_received(:update!).with(is_followed: false)
      end
    end

    context 'when follow record exists and is already unfollowed' do
      let(:follow) { build_stubbed(:follow, follower: follower, followee: followee, is_followed: false) }

      it 'raises AlreadyUnfollowError' do
        expect { service.call }.to raise_error(AlreadyUnfollowError)
      end
    end
  end
end
