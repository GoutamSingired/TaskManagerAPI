class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.date :completed_date
      t.string :status
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
