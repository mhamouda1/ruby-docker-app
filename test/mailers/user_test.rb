require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = User.new(first: 'a', last: 'a', email: 'a', password: 'a', password_confirmation: 'a')
    assert user.valid?
  end

  test 'invalid without name' do
    user = User.new(email: 'a')
    refute user.valid?, 'user is valid without a name'
    assert_not_nil user.errors[:first], 'no validation error for name present'
  end

  test 'invalid without email' do
    user = User.new(first: 'a')
    refute user.valid?
    assert_not_nil user.errors[:email]
  end
end
