class AddAuthorIdToTalents < ActiveRecord::Migration[6.1]
  def change
    add_reference :talents, :author, foreign_key: true, optional: true
  end
end
