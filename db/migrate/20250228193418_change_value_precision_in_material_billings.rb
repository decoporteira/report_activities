class ChangeValuePrecisionInMaterialBillings < ActiveRecord::Migration[7.0]
  def change
    change_column :material_billings, :value, :decimal, precision: 10, scale: 2
  end
end
