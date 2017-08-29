class RemoveActorIdFromProject < ActiveRecord::Migration[5.1]
  def change
    remove_reference :projects, :actor, foreign_key: true
  end
end
