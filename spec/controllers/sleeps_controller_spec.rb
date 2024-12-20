require "rails_helper"

RSpec.describe SleepsController, type: :controller do
  describe "POST #clock_in" do
    let(:user) { build_stubbed(:user) }
    let(:params) { { user_id: user.id } }

    context "when the user exists and is not currently sleeping" do
      it "creates a new sleep record and returns success" do
        allow_any_instance_of(Services::Sleep::ClockIn).to receive(:call).and_return([])

        post :clock_in, params: params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context "when parameter is invalid" do
      it "returns a invalid parameter error" do
        invalid_params = { user_id: "abc" }

        post :clock_in, params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context "when the user does not exist" do
      it "returns a not found error and not found status" do
        invalid_params = { user_id: 0 }

        post :clock_in, params: invalid_params, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context "when the user is already clocked in" do
      it "returns a AlreadyRecordSleepError error and unproccessable entity status" do
        allow_any_instance_of(Services::Sleep::ClockIn).to receive(:call).and_raise(AlreadyRecordSleepError)

        post :clock_in, params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end
  end

  describe "POST #clock_out" do
    let(:user) { build_stubbed(:user) }
    let(:params) { { user_id: user.id } }

    context "when the user exists and has an active sleep record" do
      it "closes the sleep record and returns success" do
        allow_any_instance_of(Services::Sleep::ClockOut).to receive(:call).and_return([])

        post :clock_out, params: params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context "when parameter is invalid" do
      it "returns a invalid parameter error" do
        invalid_params = { user_id: "abc" }

        post :clock_out, params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context "when the user does not exist" do
      it "returns a not found error" do
        invalid_params = { user_id: 0 }

        post :clock_out, params: invalid_params, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context "when there is no active sleep record for the user" do
      it "returns a AlreadyRecordSleepError error and unproccessable entity status" do
        allow_any_instance_of(Services::Sleep::ClockOut).to receive(:call).and_raise(NoSleepRecordFoundError)

        post :clock_out, params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end
  end
end
