class Project < ApplicationRecord
  has_many :actors, dependent: :destroy
  validates_presence_of :name, :description
end
