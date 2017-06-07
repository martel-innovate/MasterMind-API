class ProjectSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :name, :description, :created_at, :updated_at
  # model association
  has_many :actors
end
