class Role < ApplicationRecord
  belongs_to :role_level
  belongs_to :project
  belongs_to :actor
end
