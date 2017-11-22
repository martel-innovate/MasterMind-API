class Project < ApplicationRecord
  has_and_belongs_to_many :clusters
  has_many :roles, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :ngsi_subscriptions, dependent: :destroy
  validates_presence_of :name, :description
end
