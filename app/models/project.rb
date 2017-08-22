class Project < ApplicationRecord
  belongs_to :actor
  has_many :clusters, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :services, dependent: :destroy
  validates_presence_of :name, :description
end
