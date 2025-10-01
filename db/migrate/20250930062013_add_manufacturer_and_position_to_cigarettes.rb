class AddManufacturerAndPositionToCigarettes < ActiveRecord::Migration[7.2]
  def change
    add_column :cigarettes, :manufacturer, :string, null: false
    add_column :cigarettes, :position, :integer, null: false

    add_index :cigarettes, :name, unique: true
    add_index :cigarettes, [ :manufacturer, :position ], unique: true
  end
end
