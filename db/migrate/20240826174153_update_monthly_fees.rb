class UpdateMonthlyFees < ActiveRecord::Migration[7.0]
  def change
    add_column :monthly_fees, :has_discount, :boolean, default: false, null: false
    add_column :monthly_fees, :discount_rate, :decimal, precision: 5, scale: 2
  end
end
