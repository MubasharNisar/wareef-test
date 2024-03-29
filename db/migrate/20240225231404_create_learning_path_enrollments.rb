class CreateLearningPathEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :learning_path_enrollments do |t|
      t.references :talent, null: false, foreign_key: true
      t.references :learning_path, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
