class RenameAndChangePlanTypeToName < ActiveRecord::Migration[7.0]
  def change
    rename_column :plans, :plan_type, :name
    change_column :plans, :name, :string
  end
end
