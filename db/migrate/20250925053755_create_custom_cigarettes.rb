class CreateCustomCigarettes < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_cigarettes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
