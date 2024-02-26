class AddStatusToLearningPaths < ActiveRecord::Migration[6.1]
  def change
    add_column :learning_paths, :status, :integer
  end
end
