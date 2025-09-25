class CreateCigarettes < ActiveRecord::Migration[7.2]
  def change
    create_table :cigarettes do |t|
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
