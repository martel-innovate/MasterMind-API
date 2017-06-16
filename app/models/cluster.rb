class Cluster < ApplicationRecord
  belongs_to :project
  validates_presence_of :name, :description, :endpoint, :cert, :key, :ca
end
