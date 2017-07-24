class Project < ApplicationRecord
  belongs_to :actor
  has_many :clusters
  has_many :roles
  has_many :services
  validates_presence_of :name, :description
end
