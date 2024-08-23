class RenameNameToTypeInPlans < ActiveRecord::Migration[7.0]
  def change
    rename_column :plans, :name, :type
    change_column :plans, :type, :integer, using: 'type::integer'
  end
end
