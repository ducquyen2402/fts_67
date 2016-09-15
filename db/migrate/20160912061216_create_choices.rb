class CreateChoices < ActiveRecord::Migration[5.0]
  def change
    create_table :choices do |t|
      t.references :exam, foreign_key: true
      t.references :question, foreign_key: true
      t.integer :answer_id

      t.timestamps
    end
  end
end
