class CreateSmokes < ActiveRecord::Migration[7.2]
  def change
    create_table :smokes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cigarette, null: false, foreign_key: true
      t.integer :packs, null: false
      t.date :bought_date, null: false

      t.timestamps
    end
  end
end
