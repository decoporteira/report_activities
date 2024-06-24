class CreateMonthlyFees < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_fees do |t|
      t.references :student, null: false, foreign_key: true
      t.decimal :value, precision: 10, scale: 2
      t.integer :status
      t.date :due_date

      t.timestamps
    end
  end
end
