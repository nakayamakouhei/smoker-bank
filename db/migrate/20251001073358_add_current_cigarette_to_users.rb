class AddCurrentCigaretteToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :current_cigarette, foreign_key: { to_table: :cigarettes }
  end
end
