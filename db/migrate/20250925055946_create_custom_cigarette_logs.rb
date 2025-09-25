class CreateCustomCigaretteLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_cigarette_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :custom_cigarette, null: false, foreign_key: true
      t.integer :packs, null: false
      t.date :bought_date, null: false

      t.timestamps
    end
  end
end
