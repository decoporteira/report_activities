class AddPaymentDateToMonthlyFees < ActiveRecord::Migration[7.0]
  def change
    add_column :monthly_fees, :payment_date, :date
  end
end
