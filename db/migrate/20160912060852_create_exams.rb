class CreateExams < ActiveRecord::Migration[5.0]
  def change
    create_table :exams do |t|
      t.integer :status, default: 0
      t.integer :spent_time
      t.datetime :end_time
      t.integer :score
      t.references :user, foreign_key: true
      t.references :subject, foreign_key: true

      t.timestamps
    end
  end
end
