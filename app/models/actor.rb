class Actor < ApplicationRecord
  belongs_to :project
  validates_presence_of :email, :fullname
end
