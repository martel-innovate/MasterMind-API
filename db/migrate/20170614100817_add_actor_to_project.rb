class AddActorToProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :projects, :actor, foreign_key: true
  end
end
