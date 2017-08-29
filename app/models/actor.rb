class Actor < ApplicationRecord
  has_many :roles
  validates_presence_of :email, :fullname
end
