class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments do |t|
      t.references :talent, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
