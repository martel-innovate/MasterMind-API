class ActorSerializer < ActiveModel::Serializer
  # attributes to be serialized
  attributes :id, :email, :fullname
  # model association
  has_many :projects
end
