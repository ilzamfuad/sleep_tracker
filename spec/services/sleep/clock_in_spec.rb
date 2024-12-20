require 'rails_helper'

RSpec.describe Services::Sleep::ClockIn do
  let(:user) { build_stubbed(:user) }
  let(:service) { described_class.new(user.id) }

  before do
    allow(User).to receive(:find_by).with(id: user.id).and_return(user)
    allow_any_instance_of(SleepRecord).to receive(:save!).and_return(true)
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

    context 'when there is an active sleep record' do
      let(:sleep_record) { build_stubbed(:sleep_record, user: user, status: 'active') }

      before do
        allow(SleepRecord).to receive(:get_record).with(user.id).and_return([ sleep_record ])
      end

      it 'raises AlreadyRecordSleepError' do
        expect { service.call }.to raise_error(AlreadyRecordSleepError)
      end
    end

    context 'when there is no active sleep record' do
      it 'sets the sleep record status to active' do
        result = service.call
        expect(result.first.status).to eq('active')
      end

      it 'sets the sleep record user_id to the given user_id' do
        result = service.call
        expect(result.first.user_id).to eq(user.id)
      end

      it 'sets the sleep record sleep_time to the current time' do
        time_now = Time.now
        allow(Time).to receive(:now).and_return(time_now)
        result = service.call
        expect(result.first.sleep_time).to eq(time_now)
      end
    end
  end
end
