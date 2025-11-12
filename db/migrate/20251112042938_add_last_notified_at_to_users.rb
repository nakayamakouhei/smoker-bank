class AddLastNotifiedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :last_notified_at, :datetime
  end
end
