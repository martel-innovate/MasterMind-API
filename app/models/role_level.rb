class RoleLevel < ApplicationRecord
  has_many :roles, dependent: :destroy
end
