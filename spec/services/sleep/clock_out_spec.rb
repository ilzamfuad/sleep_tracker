require 'rails_helper'

RSpec.describe Services::Sleep::ClockOut, type: :service do
  let(:user) { build_stubbed(:user) }
  let(:service) { described_class.new(user.id) }
  let(:sleep_record) { build_stubbed(:sleep_record, user: user, status: 'inactive') }


  before do
    allow(User).to receive(:find_by).with(id: user.id).and_return(user)
    allow(SleepRecord).to receive(:get_record).with(user.id).and_return([ sleep_record ])
    allow(sleep_record).to receive(:save!).and_return(true)
  end

  describe '#call' do
    context 'when user record is not found' do
      before do
        allow(User).to receive(:find_by).with(id: user.id).and_return(nil)
      end

      it 'raises UserNotFoundError' do
        expect { service.call }.to raise_error(UserNotFoundError)
      end
    end

    context 'when no sleep record is found' do
      before do
        allow(SleepRecord).to receive(:get_record).with(user.id).and_return([])
      end

      it 'raises NoSleepRecordFoundError' do
        expect { service.call }.to raise_error(NoSleepRecordFoundError)
      end
    end

    context 'when sleep record is inactive' do
      let(:sleep_record) { build_stubbed(:sleep_record, user: user, status: 'inactive') }

      it 'raises NoSleepRecordFoundError' do
        expect { service.call }.to raise_error(NoSleepRecordFoundError)
      end
    end

    context 'when sleep record sleep_time is greater than current time' do
      let(:sleep_record) { build_stubbed(:sleep_record, user: user, sleep_time: Time.now + 1.hour) }

      it 'raises NoSleepRecordFoundError' do
        expect { service.call }.to raise_error(NoSleepRecordFoundError)
      end
    end

    context 'when valid sleep record is found' do
      let(:sleep_record) { build_stubbed(:sleep_record, user: user, sleep_time: Time.now - 8.hours, status: 'active') }

      it 'updates the sleep record with wake_time and duration' do
        result = service.call

        expect(result.first.wake_time).to be_within(1.second).of(Time.now)
        expect(result.first.status).to eq('inactive')
      end
    end
  end
end
