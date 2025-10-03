class AddCurrentCustomCigaretteIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :current_custom_cigarette_id, :bigint
  end
end
