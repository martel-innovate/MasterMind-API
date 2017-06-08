class Actor < ApplicationRecord
  belongs_to :project
  has_many :roles
  validates_presence_of :email, :fullname
end
