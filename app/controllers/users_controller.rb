class UsersController < ApplicationController
  def list_sleeps
    form = ::Form::User::UserSleepList.new(permitted_params)
    raise InvalidParameterError unless form.valid?
    list_sleeps = Services::UserFollow::List.new(form.id).call

    render_response(list_sleeps, Serializer::SleepListSerializer, status: 200)
  end

  def follow
    form = ::Form::User::UserFollow.new(permitted_follow_params)
    raise InvalidParameterError unless form.valid?

    Services::UserFollow::Dofollow.new(form.follower_id, form.followee_id).call

    render_message("You are now following this user")
  end

  def unfollow
    form = ::Form::User::UserFollow.new(permitted_follow_params)
    raise InvalidParameterError unless form.valid?

    Services::UserFollow::Unfollow.new(form.follower_id, form.followee_id).call

    render_message("You are now unfollowing this user")
  end

  private

  def permitted_params
    params.permit(:id).to_h
  end

  def permitted_follow_params
    params.permit(:follower_id, :followee_id).to_h
  end
end
