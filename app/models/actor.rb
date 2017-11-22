class Actor < ApplicationRecord
  has_many :roles
  validates_presence_of :email, :fullname
  validates_inclusion_of :superadmin, :in => [true, false]
end
