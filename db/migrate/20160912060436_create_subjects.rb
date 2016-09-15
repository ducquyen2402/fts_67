class CreateSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.float :duration
      t.text :description
      t.integer :duration, default: 20

      t.timestamps
    end
  end
end
