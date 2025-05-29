class AddValuePerHourAndTeacherToCurrentPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :current_plans, :value_per_hour, :decimal
    add_reference :current_plans, :teacher, null: true, foreign_key: true
  end
end
