class DropItemsTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :items
  end

  def down
    create_table :items do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.timestamps
    end
  end
end
