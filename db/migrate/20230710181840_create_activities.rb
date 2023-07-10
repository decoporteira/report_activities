class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.string :report
      t.integer :late
      t.integer :missing
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
