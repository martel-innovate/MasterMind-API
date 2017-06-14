class RemoveProjectFromActor < ActiveRecord::Migration[5.1]
  def change
    remove_reference :actors, :project, foreign_key: true
  end
end
