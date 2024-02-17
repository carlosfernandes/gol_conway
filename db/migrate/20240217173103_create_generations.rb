class CreateGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :generations do |t|
      t.string :state
      t.integer :order
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
