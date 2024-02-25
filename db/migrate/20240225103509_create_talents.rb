class CreateTalents < ActiveRecord::Migration[6.1]
  def change
    create_table :talents do |t|
      t.string :name

      t.timestamps
    end
  end
end
