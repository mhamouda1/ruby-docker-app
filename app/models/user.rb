class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :first, presence: true
  validates :last, presence: true
  validates :password, presence: true
end
