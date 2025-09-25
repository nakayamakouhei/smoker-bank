class CreateCigarettes < ActiveRecord::Migration[7.2]
  def change
    create_table :cigarettes do |t|
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
