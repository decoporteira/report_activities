class AddPlanTypeToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :billing_type, :integer
  end
end
