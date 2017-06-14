class Project < ApplicationRecord
  belongs_to :actor
  has_many :roles
  validates_presence_of :name, :description
end
