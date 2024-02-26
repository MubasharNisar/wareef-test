class AddEmailToTalents < ActiveRecord::Migration[6.1]
  def change
    add_column :talents, :email, :string
  end
end
