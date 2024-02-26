class CreateLearningPathCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :learning_path_courses do |t|
      t.references :learning_path, foreign_key: true, null: false
      t.references :course, foreign_key: true, null: false
      t.integer :sequence, null: false

      t.timestamps
    end

    add_index :learning_path_courses, [:learning_path_id, :sequence], unique: true
  end
end
