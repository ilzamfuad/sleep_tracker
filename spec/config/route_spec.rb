require 'rails_helper'

RSpec.describe 'Routes', type: :routing do
  it 'routes /up to the rails health check' do
    expect(get: '/up').to route_to(controller: 'rails/health', action: 'show')
  end

  it 'routes /users/:id/sleep to the users controller list_sleeps action' do
    expect(get: '/users/1/sleeps').to route_to(controller: 'users', action: 'list_sleeps', id: '1')
  end

  it 'routes /users/follow to the users controller follow action' do
    expect(post: '/users/follows').to route_to(controller: 'users', action: 'follow')
  end

  it 'routes /users/follow to the users controller unfollow action' do
    expect(delete: '/users/follows').to route_to(controller: 'users', action: 'unfollow')
  end

  it 'routes /sleeps/clock-ins to the sleep controller clock_in action' do
    expect(post: '/sleeps/clock-ins').to route_to(controller: 'sleeps', action: 'clock_in')
  end

  it 'routes /sleeps/clock-outs to the sleep controller clock_out action' do
    expect(post: '/sleeps/clock-outs').to route_to(controller: 'sleeps', action: 'clock_out')
  end
end
