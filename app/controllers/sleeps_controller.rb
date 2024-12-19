class SleepsController < ApplicationController
  def clock_in
    form = ::Form::Sleep::Clock.new(permitted_params)
    raise InvalidParameterError unless form.valid?

    user_sleep_clock = Services::Sleep::ClockIn.new(form.user_id).call
    render_response(user_sleep_clock, Serializer::UserSleepClockSerializer, status: 200)
  end

  def clock_out
    form = ::Form::Sleep::Clock.new(permitted_params)
    raise InvalidParameterError unless form.valid?

    user_sleep_clock = Services::Sleep::ClockOut.new(form.user_id).call
    render_response(user_sleep_clock, Serializer::UserSleepClockSerializer, status: 200)
  end

  private

  def permitted_params
    params.permit(:user_id).to_h
  end
end
