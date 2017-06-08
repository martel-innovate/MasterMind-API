class Project < ApplicationRecord
  has_many :actors
  has_many :roles
  validates_presence_of :name, :description
end
