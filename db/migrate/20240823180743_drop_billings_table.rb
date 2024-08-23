class DropBillingsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :billings
  end
end
