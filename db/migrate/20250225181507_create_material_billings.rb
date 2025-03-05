class CreateMaterialBillings < ActiveRecord::Migration[7.0]
  def change
    create_table :material_billings do |t|
      t.string :name
      t.integer :status
      t.references :student, null: false, foreign_key: true
      t.date :date
      t.decimal :value

      t.timestamps
    end
  end
end
