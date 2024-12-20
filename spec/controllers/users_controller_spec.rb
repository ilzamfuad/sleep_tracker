require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #list_sleeps' do
    let(:user) { build_stubbed(:user) }
    let(:params) { { id: user.id } }

    context 'when the user exists' do
      it 'returns the list of sleeps' do
        allow_any_instance_of(Services::UserFollow::List).to receive(:call).and_return([])

        get :list_sleeps, params: params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end

    context 'when parameter is invalid' do
      it 'returns a invalid parameter error' do
        invalid_params = { id: 'abc' }

        get :list_sleeps, params: invalid_params

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(InvalidParameterError.new.message)
      end
    end

    context 'when the user does not exist' do
      it 'returns a not found error and not found status' do
        invalid_params = { id: 0 }

        get :list_sleeps, params: invalid_params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(UserNotFoundError.new.message)
      end
    end
  end

  describe 'POST #follow' do
    let(:follower) { build_stubbed(:user) }
    let(:followee) { build_stubbed(:user) }
    let(:params) { { follower_id: follower.id, followee_id: followee.id } }

    context 'when the follower and followee exist' do
      it 'creates a follow relationship' do
        allow_any_instance_of(Services::UserFollow::Dofollow).to receive(:call).and_return(nil)

        post :follow, params: params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('You are now following this user')
      end
    end

    context 'when parameter is invalid' do
      it 'returns a invalid parameter error' do
        invalid_params = { follower_id: "abc", followee_id: follower.id }

        post :follow, params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(InvalidParameterError.new.message)
      end
    end

    context 'when the follower tries to follow themselves' do
      it 'returns a FollowSelfError error and unproccessable entity status' do
        invalid_params = { follower_id: follower.id, followee_id: follower.id }

        post :follow, params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(FollowSelfError.new.message)
      end
    end

    context 'when either the follower or followee does not exist' do
      it 'returns a not found error' do
        invalid_params = { follower_id: 0, followee_id: followee.id }

        post :follow, params: invalid_params, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(UserNotFoundError.new.message)
      end
    end

    context 'when the follower already follow followee' do
      it 'returns a FollowSelfError error and unproccessable entity status' do
        allow_any_instance_of(Services::UserFollow::Dofollow).to receive(:call).and_raise(AlreadyFollowError)

        post :follow, params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to be_a(Hash)
      end
    end
  end

  describe 'DELETE #unfollow' do
    let(:follower) { build_stubbed(:user) }
    let(:followee) { build_stubbed(:user) }
    let(:params) { { follower_id: follower.id, followee_id: followee.id } }

    context 'when the follower and followee exist' do
      it 'removes the follow relationship' do
        allow_any_instance_of(Services::UserFollow::Unfollow).to receive(:call).and_return(nil)

        delete :unfollow, params: params, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('You are now unfollowing this user')
      end
    end

    context 'when parameter is invalid' do
      it 'returns a invalid parameter error' do
        invalid_params = { follower_id: "abc", followee_id: follower.id }

        delete :unfollow, params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(InvalidParameterError.new.message)
      end
    end

    context 'when the follower tries to unfollow themselves' do
      it 'returns a UnfollowSelfError error and unproccessable entity status' do
        invalid_params = { follower_id: follower.id, followee_id: follower.id }

        delete :unfollow, params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(UnfollowSelfError.new.message)
      end
    end

    context 'when either the follower or followee does not exist' do
      it 'returns a not found error' do
        invalid_params = { follower_id: 0, followee_id: followee.id }

        delete :unfollow, params: invalid_params, as: :json

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to be_a(Hash)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(UserNotFoundError.new.message)
      end
    end

    context 'when the follower not following yet' do
      it 'returns a FollowSelfError error and unproccessable entity status' do
        allow_any_instance_of(Services::UserFollow::Unfollow).to receive(:call).and_raise(NotFollowError)

        delete :unfollow, params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(NotFollowError.new.message)
      end
    end

    context 'when the follower already unfollow followee' do
      it 'returns a AlreadyUnfollowError error and unproccessable entity status' do
        allow_any_instance_of(Services::UserFollow::Unfollow).to receive(:call).and_raise(AlreadyUnfollowError)

        delete :unfollow, params: params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors'][0]['message']).to eq(AlreadyUnfollowError.new.message)
      end
    end
  end
end
