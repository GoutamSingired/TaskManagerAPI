class AddProgressToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :progress, :integer
  end
end
