class Cluster < ApplicationRecord
  has_and_belongs_to_many :project
  validates_presence_of :name, :description, :endpoint, :cert, :key, :ca
end
