class AddTotalToCurrentPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :current_plans, :total, :decimal, precision: 10, scale: 2
  end
end
