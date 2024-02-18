class AddFinalColumnToGenerations < ActiveRecord::Migration[7.1]
  def change
    add_column :generations, :final, :boolean, default: false
  end
end
