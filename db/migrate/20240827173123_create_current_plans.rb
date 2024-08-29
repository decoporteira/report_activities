class CreateCurrentPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :current_plans do |t|
      t.references :plan, null: false, foreign_key: true
      t.boolean :has_discount, default: false, null: false
      t.integer :discount
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
