class RemoveStatusFromLearningPathAndCourse < ActiveRecord::Migration[6.1]
  def change
    remove_column :learning_paths, :status, :integer
    remove_column :courses, :status, :integer
  end
end
